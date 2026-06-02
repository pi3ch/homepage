---
date: '2026-06-02T10:00:04+10:00'
draft: flase
title: 'Using AI to Secure Its Own Code Is a Ponzi Scheme'
tags: ["AI", "security", "vibe", "code", "learning"]
cover:
  image: '/blog/images/using-ai-scan-its-own-code-is-ponzi-scheme.png'
---

*AI can tell you what your software does. It cannot tell you what your software must never do. So you should not rely on it*

If I wrote my own financial audit report and handed it to you, would you give me a loan?

Most people would not. A self-certified audit tells you nothing because the auditor and the auditee are the same person.

This is similarly happens when you ask AI to verify the security of code that AI wrote. The conflict is identical. Paying for more audits does not fix it. Every audit cycle costs more tokens, produces more confidence, and leaves the underlying liability untouched.

This is the structure of a Ponzi scheme. Early returns look real. The liability grows in the dark. The collapse comes when someone external comes to collect. In a financial Ponzi scheme, that is the investor who wants their money back. They were never inside the loop. They do not care about the audit report. They just want to see the money. 

In software security, that someone is the adversary.

## What Vibe Coding Actually Delivers

When you vibe code, you describe a feature in natural language, the AI generates the code, and it works. For functional requirements, this is a legitimate productivity gain.

A functional requirement defines what software should do. The user authenticates, the payment processes, the API returns the expected response. These requirements are bounded and testable. You can write a test, run it, and get a pass or fail. AI handles this well.

The problem is that software has another category of requirements. Non-functional requirements define how software should behave under load, under failure, and under attack. Security sits here. It is not about what the software does. It is about what the software must never do.

That distinction matters because the verification methods are fundamentally different. Functional requirements have a known expected output you can test against. Security requirements have no finite expected output. You cannot enumerate every way a system can be exploited.


## The Ponzi Mechanics

Imagine a fund manager who promises high returns on your investment. You invest, and shortly after you receive a return. You are satisfied, so you invest more and tell your friends. They invest too. What you do not know is that your return was not generated from any real profit. It was paid using the money your friends just deposited. The fund has never actually made anything. As long as new investors keep joining, the manager can keep paying returns and the scheme stays alive. The moment new money stops coming in, there is nothing left to pay anyone.

That is how a Ponzi scheme works. The early returns are real. The mechanism behind them is not.

Using AI to review vibe coded software follows the same pattern. You prompt the AI to generate code, the tests pass. You pay for an AI security scan, it surfaces some issues, the AI fix them and ship the feature. Each AI cycle produces a report that looks reasonable. 

The AI vendor profits on every iteration because more code means more tokens to generate it, more tokens to scan it, and more findings means more tokens to fix. The security reports keep looking good, confidence keeps growing, and the loop continues until an adversary finds a vulnerability and tells you otherwise.

**The underlying attack surface has never been independently verified. It has only been assessed by the same system that created it. That is not a security audit. That is a self-certified statement.**

Ponzi schemes collapse when someone outside the loop comes to collect and discovers the money was never there. In software security, that outside party is the adversary. They are not part of your development cycle, they did not read your security report, and they only need to find one thing to prove your software is not secure.

## Functional and Non-Functional Requirements

To understand why security behaves this way, we need to look at how software requirements are defined.

Software requirements are divided into two categories. **Functional requirements define what a system should do.** A user can register an account, upload a file, or place an order. These are concrete, observable behaviours. You can write a test for each one, run it, and confirm whether the software satisfies it.

**Non-functional requirements define how a system should behave across all conditions.** Performance, reliability, maintainability, and security all live here. They are not about specific features. They are about the properties of the system as a whole.

Security is a non-functional requirement, but it has a characteristic that makes it different from the others. Performance has measurable thresholds. Reliability can be tested under simulated failure conditions. Security cannot be defined the same way because it is expressed as a negative requirement. It is not about what the software should do. It is about what the software must never do.

In software engineering, this is modelled through misuse cases. A use case describes a legitimate interaction: a user logs in with valid credentials and gets access. A misuse case describes the adversarial version: an attacker bypasses the login without valid credentials. For every feature you build, there is a set of misuse cases that describe how it can be abused.

The critical difference is that use cases are defined by you. You write them, you know them, and you test against them. Misuse cases are defined by the adversary. They do not share the list with you. Every new feature, every new dependency, every new integration expands that list in ways you cannot fully anticipate.

This is why security is the sky. Functional requirements are the floor. The floor is measurable and finite. The sky has no ceiling.

## The Oracle Problem and Gödel

To understand why security cannot be verified by the same system that generates it, we need to look at some foundational theories. Out of many in this field, two are particularly relevant here.

### The Oracle Problem

In software testing, an oracle is the mechanism that tells you whether a test passed or failed. For functional requirements, the oracle is straightforward. You test a login function with valid credentials and expect access to be granted. You test it with invalid credentials and expect it to be denied. The oracle exists because you know the expected output in advance.

Now consider testing whether a login cannot be bypassed by any means. What does the oracle look like here? What does passing mean? 

Take SQL injection and OAuth token hijacking as examples. If you know about them, you can test for them. But does covering those two mean you have covered every misuse case? What about the attack technique that does not have a name yet? There is no complete answer to that question because **the space of possible bypass techniques is unbounded.** You would need to enumerate every possible way the system could be abused, including techniques that do not exist yet, to write a complete oracle. That is a theoretical impossibility.

When you ask AI to verify the security of code, you are asking it to be that oracle. It cannot be, for the same reason no oracle can exist for the secure system.

### Gödel's Incompleteness Theorem

In 1931, Kurt Gödel proved that any sufficiently complex formal system **cannot** prove its own consistency from within itself. Consider this rulebook:

> *Rule 1: Sentences must end with a full stop.*

> *Rule 2: All rules must be written in English.*

> *Rule 3: No rule may contradict another rule.*

> *Rule 4: This rulebook contains no errors.*

Rule 4 cannot be trusted. The rulebook has no mechanism to see its own mistakes. Only someone or a system outside the rulebook can verify whether it is actually error-free.

When you use AI to audit AI-generated code, you are asking the rulebook to check itself. The two systems share the same training data, the same known vulnerability patterns, and the same conceptual boundaries. What they share equally are their blind spots. 

## Why AI Security Scanning of Its Own Code Is Structurally Incapable

The oracle problem and Gödel's theorem describe what is happening when you use AI to audit vibe coded software.

**The oracle problem tells us that there is no ground truth to test security against.** When an AI security scanner runs against your code, it does not verify the absence of vulnerabilities. It matches your code against patterns it has seen before. It finds what it knows to look for. Everything outside that pattern library is invisible to it. The scan result is not a measure of how secure your code is. It is a measure of how well your code avoids known bad patterns.

**Gödel tells us that using the same system to verify its own output is a closed loop.** The AI that generated your code and the AI that audits it share the same training distribution, the same architectural assumptions, and the same conceptual boundaries. When the auditing AI clears your code, it is not providing independent verification. It is confirming that the code does not violate patterns it already knows about. The blind spots of the generator and the auditor are the same.

This is not a criticism of any particular model or vendor. **A more powerful model does not escape this problem.** A larger context window does not escape this problem. These are improvements along dimensions the system can already measure. They do not address what the system cannot see. The only way out of a closed loop is to step outside it.

## Why AI Seems Good at Finding Vulnerabilities Today

AI security tooling performs reasonably well right now. Most production code in libraries, open source repositories was written prior to AI mostly by humans. The vulnerability patterns in that code are documented, they appear in CVE databases, they are discussed in security research, and they are well represented in training data. When an AI scanner finds a broken access control issue in a human-written codebase, it is doing sophisticated pattern matching against its training dataset.

But this capability is a product of the current moment, not a property of the AI technology.

### First Decay Vector: Vibe Coded Code Flooding the Training Data

As vibe coding scales, the ratio of AI-generated code in open source grows. AI-generated code has different structural patterns, different ways of handling edge cases, and different architectural assumptions compared to human-written code. 

**The vulnerability classes native to AI-generated code are not yet well documented because the code is new and attacks against it have not fully matured.** The AI scanner has no external signal telling it that its pattern library is becoming stale. It keeps producing security reports that look reasonable while the gap between what it can see and what actually exists widens.

### Second Decay Vector: New Technologies, New Vulnerability Classes

New technologies consistently produce vulnerability classes that did not exist before them. 

For example, OAuth was introduced around 2007 and within a few years delegated authorisation produced an entirely new family of attacks — token leakage, open redirect abuse, implicit flow hijacking — that no prior security model had anticipated. 

Ethereum's execution model, introduced in 2015, created the conditions for reentrancy attacks. The DAO hack in 2016 was the first large-scale realisation of a vulnerability class that could not have existed before smart contracts. 

Prompt injection did not exist before LLMs were given agency. 
Each of these attack classes was invisible to security scanning tool at the time until researchers and adversaries discovered and documented them.

AI-native architectures, agentic systems, and MCP tool chains are introducing new execution models and new trust boundaries right now. The attack classes native to these technologies are still forming. No AI security scanner has meaningful training data on them yet because the attacks have not been documented. The scanner will not tell you this. It will run, produce a report, and look confident.

## Your Sovereignty and Skill Development

The way out of a closed loop is to step outside it! 

In practice, that means developing the skills to independently evaluate what AI generates.

This is not an argument against using AI. It is an argument against outsourcing your judgment to it. There is a meaningful difference between a developer who uses AI to accelerate their work and a developer who uses AI as a substitute for understanding. The first can read what the AI produces and evaluate it critically. The second has no basis to question it at all.

Security knowledge is what makes that difference. A developer who understands how SQL injection works can spot a vulnerable query in AI-generated code or can enhance her prompt to avoid it. A developer who does not know how SQL injection works is entirely dependent on the AI scanner catching it, which brings us back to the closed loop. The scanner and the generator share the same blind spots, and the developer has no independent means to see what both of them missed.

This is what sovereignty means in practice. Not avoiding AI tools, but retaining the capacity to judge their output. 

The dependency itself is the risk. As developers increasingly rely on AI to generate and review code, [the knowledge required to evaluate that code independently is quietly eroding](https://pedramhayati.com/blog/ai-impact-secure-code-learning/). There is no external signal marking this erosion as it happens. It becomes visible only when the adversary arrives and nobody in the room understands what went wrong or why.

Skill development is not a supplement to AI-assisted development. It is the only external verifier the closed loop cannot replace.
