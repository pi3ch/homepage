---
date: '2022-09-11T10:59:00+10:00'
title: 'Do not use String to store secret. It gets disclosed'
draft: false
tags: ["security", "programming", "secrets", "best practices", "design patterns"]
---

_This article was originally published on [SecDim](https://discuss.secdim.com/t/do-not-use-string-to-store-secret-it-gets-disclosed/247)._

We all know secret keys, passwords, API keys, tokens, payment card data (pin, pan, track2 data, cvv) should never be hard coded. We use environment vars, vault, hardware security module (HSM) to protect these secrets.

But what about when they are being processed by a program?

**They remain unprotected and plaintext in the memory** for unforeseeable or long time.

Why do we care?

If they remain unprotected in the memory, they can get disclosed (see this security breach). Crash logs, caching, or memory paging are a few cases where secrets can get disclosed, stored unprotected on the disk or logged on external systems. For example, this is an excerpt from Tomcat's documentation:

> Whenever Apache Tomcat is shut down normally and restarted, or when an application reload is triggered, the standard Manager implementation will attempt to serialize all currently active sessions to a disk.

In other word, this means secrets will be stored unprotected on the disk during normal usage of the server.

## Anti Pattern: Using String for Secret

The following code snippet exposes an API key unprotected in the memory for the lifespan of the process:

```/dev/null/apikey-antipattern.java#L1-12
class APIKey {
   String secret
   constructor(String secret) {
      this.secret = secret
   }

   String getSecret() {
     return this.secret
   }
}
```

This code has these insecure practices:
- There is more than one reference to the secret. The more reference, the longer secret remains in the memory unprotected.
- There is no guarantee when garbage collector is going to clean these fields.
- `String` is an immutable data type. An immutable type cannot be changed. Therefore, when you modify a string (say try to nullify it), a new copy of it is created. This means another copy of the unprotected secret will remain in the memory.

Is there a safer way to handle secrets?

## Read Once Defensive Design Pattern

Usually, a secret is only needed once during lifespan of the process. For example, a key to a cryptographic algorithm is only needed during initialization and it can be discarded afterwards.

Read once is a defensive design pattern where a value can be only accessed once. After the first read, value is cleared from the memory, and subsequent access is not possible.

Let's look at one simple implementation of the read once pattern.

```/dev/null/apikey-secure.java#L1-18
class APIKey {
  byte[] secret // (1)
  boolean consumed = false
  constructor(byte[] secret) {
    this.secret = secret.clone() // (2)
  }
  byte[] getValue() {
    if(consumed) { throw Exception("Secret has been already used") } // (3)
    constant byte[] clonedValue = this.value.clone()
    this.value.fill(0) // (4)
    consumed = true
    return clonedValue
  }
 // For better safety the following must be disallowed
 // Subclassing, extension or serialization
}
```

1. Byte array is mutable and can be changed
2. Passes the secret and cleared afterwards (by garbage collector)
3. Alerts if secret has been accessed again
4. Nullifies the secret after the first read

Read once is a powerful defensive design pattern that protects secrets, reduces their unnecessary exposure in the memory, and alerts if there is an unexpected access to the secret.
