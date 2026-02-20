---
date: '2026-02-17T19:35:19+11:00'
draft: false
title: 'LangChain load() is basically eval()'
tags: ["LangChain", "AI", "secure", "code", "learning"]
cover:
  image: '/blog/images/langchain-load-is-eval.jpg'
---

The patch for LangChain vulnerability CVE-2025-68665  disables loading secrets from environment variables by default, and introduces an escape wrapper to prevent injection. This is good, however, the underlying functionality is insecure-by-design and the root-cause has not been addressed.

In December 2025, [CVE-2025-68665](https://github.com/advisories/GHSA-r399-636x-v7f6), a high-severity vulnerability (CVSS 8.6) was reported on LangChain. The vulnerability was an insecure deserialisation where an adversary could hijack secrets (e.g. OpenAI API keys), and depending on the set of allowed constructors (and their side effects), it could be escalated into arbitrary code execution.

I became curious about how this vulnerability has occurred in the first place but more importantly how it is patched.

## Why this vulnerability class is dangerous

The Insecure deserialisation vulnerability class goes back to the late 1990s. One of the earliest hints of deserialisation dangers appeared in Python 1.5.1 library reference documentaton. It noted that the `pickle` module does not serialise code objects to “[avoid the possibility of smuggling Trojan horses into a program](https://web.mit.edu/people/amliu/vrut/python/lib/module-pickle.html)”. Even though `pickle` was shown in 2002 to be vulnerable to code execution, the original design decision showed that developers recognised the security risk of deserialising untrusted data. **Exposing a deserialiser to untrusted data can result in code execution and it is difficult to protect against code execution due to the sheer number of security control bypasses.**

## What the patch changed

In LangChain, a core functionality called [`load`](https://reference.langchain.com/javascript/functions/_langchain_core.load.load.html) was impacted by this vulnerability. This function is documented as “Load a LangChain object from a JSON string.” where in reality it processes and deserialises the input. If untrusted JSON data reaches `load()`, it gets parsed and interpreted!

```javascript
async function reviver(this: ReviverContext, value: unknown): Promise<unknown> {
// ...
// Check for LC constructor object
  if (
    "lc" in record &&
    "type" in record &&
    "id" in record &&
    "kwargs" in record &&
    record.lc === 1 &&
    record.type === "constructor"
  ) {
	  //SNIP
      const instance = new (builder as any)(
      mapKeys(
        kwargs as SerializedFields,
        keyFromJson,
        combineAliasesAndInvert(builder)
      )
    );
    // ...
     return instance;
  }
}
// ...
```

LangChain uses a reserved `lc` marker in JSON to represent serialised LangChain objects (constructors, secrets, etc.). The deserialiser interprets these records during `load()`.
When the input has `lc` of `1` and `type` of `constructor`, the `reviver()` resolves constructors via import maps and performs class initialisation. Whether this becomes code execution-like in practice depends on which constructors are reachable via the configured import maps and what side effects their initialisers perform.

The patch for the vulnerability has two parts:

1. During serialisation, user-controlled `kwargs` values that look like `lc` records get wrapped. For example `{ "lc": 1, "type": "secret", "id": ["OPENAI_API_KEY"] }` get transformed to `{ "__lc_escaped__": { "lc": 1, "type": "secret", ... } }`
2. During deserialisation, when the `reviver` function sees `__lc_escaped__` it unwraps, then returns the inner object as plain data and stops traversing that subtree. Therefore injected `lc` records are never interpreted as LangChain records.

```javascript
async function reviver(this: ReviverContext, value: unknown): Promise<unknown> {
// ...
  const record = value as Record<string, unknown>;
  if (isEscapedObject(record)) {
    return unescapeValue(record);
  }
// ...
}
// ...
```

## What remains risky

The escape mechanism to prevent `lc` injection is good, however, the root-cause remains insecure-by-design.

Serialisation happens in `Serializable.toJSON()` and only applies to `Serializable` inputs (e.g. `HumanMessage`, `AIMessage`). It doesn’t make `load()` safe on adversary-controlled JSON, as `reviver()` performs interpretation on arbitrary objects with minimal structural validation.

In other words, the patch has only fixed one possible exploitable route and it hasn’t addressed the core design issue: **`load()` is an interpreter, not a secure deserialiser for untrusted inputs.**

Although the documentation has been updated with [some security considerations](https://reference.langchain.com/javascript/interfaces/_langchain_core.load.LoadOptions.html), we have seen in the past that these warnings are often ignored in practice which can leave many applications exposed.

But that is not all.

`load()` also has another security design flaw and that is secret resolution. The patch set `secretsFromEnv` to `false` by default to disable resolution of secrets from environment variables. It also pushes secret resolution towards an explicit `secretsMap`.

`secretsFromEnv` is open to misuse. When set to `true`, the function can read and include any secret available to the Node.js process. Although the documentation warns against it, the existence of this feature is an insecure practice in the first place. Wildcard secret access is a known anti-pattern because it turns a single mistake into broad credential exposure.

**Secret resolution is a privileged capability. It should be injected explicitly by the host application, not inferred from user-controlled data.** Currently, the same untrusted input controls secret resolution.

Overall, the `load()` function is too powerful and [I have documented about the danger of writing powerful programs](https://learn.secdim.com/course/secure-programming-fundamentals-i/topic/defensive-programming-introduction-problem). It turns user-controllable data into objects and performs secret resolution based on the same input. The patch only “escapes” some cases. It is an example of “curing the symptom” approach. The function is an example of insecure design flaw with too many dangerous decisions relying on user-controllable input.

## An opinionated secure design proposal for load()

What I recommend as a possible secure design is to split `load()` into three distinct functions:

1. Parse
2. Validate
3. Instantiate

The key idea behind my recommended secure design is untangling security checks from the business logic in its own isolated component. As I explained in [SecDim 1st Defensive Design Principle](https://learn.secdim.com/course/defensive-programming-1st-core-principle/topic/principle-1-principle) by keeping security checks independent from application logic, we achieve a clean separation of concerns, resulting in a design that is easier to maintain and reason about.

### Parse

A public function that takes in untrusted *string* input and returns an AST-like structure of the type `UnsafeParsedAst`. Like a common parser, the objective of this function is to ensure the input is syntactically in the right format. We may also pass in the maximum depth as an option to enforce size checks and limit recursion.

```javascript
export function parse(text: string, opts?: { maxDepth?: number }): UnsafeParsedAst;
```

### Validate

This function takes in `UnsafeParsedAst` and `LoadPolicy`, validates the AST against our security policies such as:

* Allowed secret IDs
* Allowed type IDs (validated against an allowlist registry).
* Allowed kwargs

We model `UnsafeParsedAst` and `SafeParsedAst` as distinct types. The `validate` function outputs `SafeParsedAst` type that, as the type suggests, is safe for the program to process. This function fails immediately when the input violates any of the security policies.

```javascript
export type LoadPolicy = {
  allowedTypes: Set<string>;
  allowedSecretIds?: Set<string>;
  maxDepth?: number;
  maxNodes?: number;
  allowedKwargs?: Record<string, Set<string>>;
};


export function validate(ast: UnsafeParsedAst, policy: LoadPolicy): SafeParsedAst;
```

### Instantiate

This function takes in `SafeParsedAst`, resolves secrets and modules. This ensures the most dangerous part of the process is explicit and only performed on a safe input.

```javascript
export function instantiate(ast: SafeParsedAst): Promise<any>;
```

`instantiate()` is created by binding runtime capabilities up front with a registry allowlist map and a secret resolver (to avoid globals).

With this secure design the code execution and secret resolution happens on an already approved input. If the input is malformed, it would never get interpreted. Moreover, your design contracts are enforced by types via the compiler. This leaves less room for developer errors and misuse.

## What about now

My recommended secure design is a major refactor, and it could be a bit too late to get implemented in the library.

If you are a developer using LangChain:

1. Do not call `load()` on untrusted input.
2. Do not enable `secretsFromEnv`.
3. Use `secretsMap` with minimal scope.
4. Avoid broad import maps; keep allowlists minimal and static.

If you are a maintainer of LangChain:

1. At minimum, update the [load](https://reference.langchain.com/javascript/functions/_langchain_core.load.load.html) documentation and add a warning, e.g. “This is dangerous. You must exercise extreme caution. Unless the input is coming from a completely trusted source, it is trivial to introduce insecure deserialisation vulnerability using this function.”
2. Rename it to `dangerousLoad()` so the function name clearly communicates its danger (this practice has a success track record in [React](https://react.dev/reference/react-dom/components/common#dangerously-setting-the-inner-html) i.e `dangerouslySetInnerHTML`)

If you like to learn more about ready-to-use secure design patterns, have a look at [our core Defensive Design Principles](https://learn.secdim.com/learn/design).
If you like to learn how to patch insecure deserialisation, have a look at [Insecure Deserialisation secure coding challenges](https://play.secdim.com/browse?search=Insecure+Deserialisation).

Secure design decisions made early eliminate entire classes of vulnerabilities. Retrofitting safety onto an interpreter is always more expensive than designing for explicit capability boundaries from the start.

_This blog post was originally posted on [SecDim](https://secdim.com/blog/post/langchain-load-is-basically-eval-17661/)_
