---
date: '2022-09-26T06:03:00+10:00'
title: 'Avoid validation with privilege return'
draft: false
tags: ["security", "programming", "validation", "access control", "design patterns"]
---

_This article was originally published on [SecDim](https://discuss.secdim.com/t/avoid-validation-with-privilege-return/304)._

Suppose the following function checks if a `user` can access a `resource`. What can go wrong?

```/dev/null/checkaccess-insecure.java#L1-7
function checkAccess(User user, Resource resource) boolean {
  if (IsAccessAllowed(user, resource) == ACCESS_DENIED) {
    return false
  }
  return true
}
```

At first glance, it looks fine but what would happen if `isAccessAllowed` fails?

For example, system goes out of memory or it throws an exception that result into a different response. Any response aside from `ACCESS_DENIED` could make `checkAccess` to return `true`.

In other word, **any other error authorises the `user` to access the `resource`**.

The design of the above function has a security weakness and it allows for **privilege return**. It means **by default it let the action to be performed** therefore, any unforeseen error could result into a security breach (e.g. unauthorised access to a resource).

I have commonly seen this insecure design with validation functions, where it checks for a series of rules and throws an error if any rule doesn't match.

A better alternative is to **return to a low privilege by default**. This means our function should **disallow by default** unless permitted by a previous state.

```/dev/null/checkaccess-secure.java#L1-7
function checkAccess(User user, Resource resource) boolean {
  if (IsAccessAllowed(user, resource)) {
    return true
  }
  return false // (1)
}
```

1. Unprivileged return by default

Therefore, if the validation function fails due to an unexpected error, the caller does not allow access. This simple change in the design could **prevent a security breach**.

The idea of this principle is similar to [**Deny by Default**](https://csrc.nist.gov/glossary/term/deny_by_default) firewall rule that blocks inbound or outbound network traffic that has not been allowed by previous rules.

_BTW, did you know it is [always better not to validate but parse untrusted data?](https://learn.secdim.com/course/defensive-programming-1st-core-principle)_
