---
date: '2026-01-15T16:20:28+11:00'
draft: false
title: 'Three Secure Coding Lessons from A Log Injection Bug in Django'
---

![Blog post - Three Secure Coding Lessons from a Django Log Injection|690x388](https://discourse-secdim.sgp1.cdn.digitaloceanspaces.com/original/2X/3/3ffb524da2f88ca525682dad176a513ec3763d9a.jpeg)

In June 2025, a vulnerability (CVE-2025-48432) was discovered in Django that allowed remote adversaries to tamper with log output by maliciously crafting the `request.path`. This could lead to forged logs and log injection when logs are viewed in terminals. By forging logs, an adversary can introduce fake log entries that compromise log integrity and make forensic audits difficult.

In more severe cases (which is not the case here), log processing can result in code execution. This was the situation with the [Log4Shell vulnerability](https://play.secdim.com/game/java/challenge/log-injectionjava?vulnerability=Log%20Injection), where attacker-controlled log entries were parsed, interpreted, and executed by the logging subsystem.

Unlike some other frameworks, Django has long been known for its strong security posture. It is a framework that embeds a number of security features by default. When a security vulnerability is reported in Django, it is usually worth investigating and analysing in detail.

In this post, I analyse the patch and explain its pros and cons. There are important lessons we should learn here in order to avoid common pitfalls when writing security patches.

## The edge case

Looking at the [unpatched commit](https://github.com/django/django/commit/957951755259b412d5113333b32bf85871d29814/), there was a direct call to the `logger.warning` method. This method received untrusted input (e.g. `request.path`) and logged it directly.

```python
def http_method_not_allowed(self, request, *args, **kwargs):

    logger.warning(
        "Method Not Allowed (%s): %s",
        request.method,  # UNTRUSTED INPUT
        request.path,    # UNTRUSTED INPUT
        extra={"status_code": 405, "request": request},
    )
    response = HttpResponseNotAllowed(self._allowed_methods())

# SNIP

    logger.warning(
        "Gone: %s", request.path, extra={"status_code": 410, "request": request}
    )
    return HttpResponseGone()
```

For example, if an adversary sends the following request:

```
GET /foo%0D%0AFake-Entry: 200 OK/ HTTP/1.1
```

(where `%0D` = CR and `%0A` = LF), the `request.path` value becomes:

```
"/foo\r\nFake-Entry: 200 OK/"
```

Calling:

```python
logger.warning("Gone: %s", request.path)
```

produces a log entry that, when written to a text log or displayed in a terminal, is interpreted as two separate lines:

```
WARNING django.request: Gone: /foo
Fake-Entry: 200 OK/
```

The injected CRLF sequence creates a new log line: `Fake-Entry: 200 OK/`. This behaviour is known as *log forging*: the adversary creates log entries that appear to originate from the application itself.

If the adversary instead sends:

```
GET /%1B[1;31mHACKED%1B[0m/ HTTP/1.1
```

(where `%1B` = ESC, used to start ANSI colour sequences), the `request.path` becomes:

```
/\x1b[1;31mHACKED\x1b[0m/
```

When `logger.warning("Method Not Allowed (%s): %s", method, request.path)` is printed to a terminal that interprets ANSI escape codes, the word *HACKED* appears in colour and may obscure, overwrite, or manipulate subsequent log output.

This class of vulnerability is not new. I could traced it back to February 2003, when [HD Moore](https://seclists.org/bugtraq/2003/Feb/att-315/Termulation.txt) described attacks against terminal emulators. When log files containing control characters were displayed without proper escaping, this could result in information disclosure (for example, screen dumping) and even remote code execution. HD Moore reported multiple zero-day vulnerabilities affecting Apache and numerous terminal emulators.

## The patch

The approach used in the patch is known in the security community as *output escaping* (or output validation). The security patch introduced a helper method called `log_response`:

```python
def http_method_not_allowed(self, request, *args, **kwargs):

    response = HttpResponseNotAllowed(self._allowed_methods())
    log_response(
        "Method Not Allowed (%s): %s",
        request.method,
        request.path,
        response=response,
        request=request,
    )

# SNIP

    response = HttpResponseGone()
    log_response("Gone: %s", request.path, response=response, request=request)
    return response
```

`log_response` is a wrapper in `django.utils.log` that ultimately calls `log_message`, where the log message arguments are escaped:

```python
def log_message(
    logger,
    message,
    *args,
    level=None,
    status_code=None,
    request=None,
    exception=None,
    **extra,
):
    # SNIP
    escaped_args = tuple(
        a.encode("unicode_escape").decode("ascii") if isinstance(a, str) else a
        for a in args
    )
```

The function iterates over the arguments and, if an argument is a string, converts it using Python’s internal `unicode_escape` encoding. This encoding transforms non-printable and non-ASCII characters into backslash escape sequences. For example, control characters such as ESC become `\x1b`. Other examples include:

* `s = "A\nB"` → `s.encode("unicode_escape")` → `b'A\\nB'`
* `s = "/\x1b[1;31mHACK\x1b[0m/"` → `b'/\\x1b[1;31mHACK\\x1b[0m/'`
* `s = "✓"` → `b'\\u2713'` (non-ASCII BMP character)
* `s = "𐍈"` → `b'\\U00010348'` (non-BMP character)
* Backslashes are escaped (a backslash in the input becomes `b'\\'`)

`a.encode("unicode_escape")` returns bytes, and `.decode("ascii")` converts those bytes back into a string suitable for logging APIs that expect text.

In short, this patch transforms strings into their `unicode_escape` representation by making control characters and terminal escape sequences visible. As a result:

* CR/LF characters (`\r` and `\n`) become explicit, preventing log forging via injected newlines.
* ANSI escape sequences become visible, preventing colour codes from obscuring or manipulating log output in terminals.

## The patch is good but insufficient

The patch does not consider whether the input contains malicious (non-conforming) characters. **It assumes that output of the `unicode_escape` method is safe to send to consoles and text logs.**

This is a strong assumption.

If the output is consumed in a different context — such as HTML, SQL, or JSON — this patch is insufficient. For example, the current patch allows characters such as `<`, `>`, `(`, and `)`. As a result, an attacker could inject `<script>alert(1)</script>`, which may be interpreted and executed by an HTML-based log viewer, leading to a second-order XSS vulnerability.

The first secure coding lesson we learn here is therefore to **perform context-aware output escaping**.

## Lesson 1: Perform context-aware output escaping

Untrusted data must be transformed into a format that is safe for the *specific output context* in which it will be rendered. While `unicode_escape` may be safe for console or terminal output, it is not safe when the same data is rendered in a web page.

Whenever you escape potentially malicious characters, ensure that the escaping mechanism is appropriate for the target context.

## Lesson 2: Only accept the known good

A fundamental secure design principle is to accept only input that conforms to known, expected requirements and reject everything else. This limits exposure to data you understand and can safely process, substantially reducing the space of possible malicious inputs.

In application design, this principle can often be enforced at the boundaries. However, as demonstrated here, in a generic framework component such as logging, rejecting input is not feasible — logs must capture all data, including malformed or malicious input.

In such cases, the second-best option is to ensure that processing and output handling are done securely. This approach is more complex and error-prone, but usability requirements often leave no alternative.

## Lesson 3: Make your patch future-proof

Code evolves. Assumptions change. The inputs to your methods and the contexts in which their outputs are consumed are not fixed. This means that code which is secure today can become insecure tomorrow.

A good example is the shift towards centralised log aggregation over the past decade. Logs are commonly funnelled to a central server and displayed through web applications (SIEMs, log analytics dashboards, etc.). This shift gave rise to second-order XSS vulnerabilities: attackers could inject `<script>` tags into logs, which were later rendered and executed by web-based log viewers, potentially leading to SOC account compromise.

You can find real-world example of this exact issue in the following cases :

* Kibana “Discover” page XSS, where logs indexed into Elasticsearch were unsafely rendered in a browser (CVE-2017-8440)
* Splunk Web XSS (CVE-2014-8301)

Escaping at one layer is not a contract; it is an implementation detail that future consumers may invalidate. As such, the current patch is not future-safe.

To mitigate this risk, adopt programming patterns where violated assumptions cause the system to fail loudly rather than silently becoming insecure. This itself is a big topic that I will cover in another post.

## Conclusion

Security vulnerabilities are often discussed in terms of input validation, but this incident is a reminder that output handling is equally critical. Data does not become safe simply because it has passed through internal APIs; it becomes safe only in relation to the context in which it is consumed.

In the case of Django (CVE-2025-48432), unescaped control characters in log output enabled log forging and terminal manipulation. While the impact was limited, the underlying class of vulnerability has a long history and has repeatedly resurfaced as systems evolved.

The patch introduced by Django correctly neutralises control characters for terminal and text-log contexts. However, it also illustrates a broader lesson: **escaping strategies are context-specific and time-bound**. What is safe for a terminal today may be unsafe when the same data is rendered in a browser tomorrow.

Robust security patches should therefore aim to:

* treat output encoding as a contextual concern rather than a universal solution,
* minimise assumptions about how data will be consumed in the future,
* and, where possible, enforce contracts that fail loudly when those assumptions no longer hold.

Here are some Log injection secure code learning challenge for you to try to patch: [Log injection secure coding challenges](https://play.secdim.com/browse?search=Log+Injection)

Happy patching.
