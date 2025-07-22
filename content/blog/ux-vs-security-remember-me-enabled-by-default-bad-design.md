---
date: '2016-04-23T10:00:00+10:00'
title: 'UX vs Security - Remember Me enabled by default is a bad design'
draft: false
tags: ["security", "ux", "authentication", "remember me", "cookies", "login", "user experience"]
---

_This article was originally published on [elttam](https://web.archive.org/web/20180319004657/https://www.elttam.com.au/blog/ux-vs-security-security-challenge/)._

**Remember Me** is a checkbox in a login form to enable remembering a user session and keeping a user authenticated for a prolonged period of time. From a UX perspective, Remember Me **improves the user convenience** as it eliminates the need for re-authentication. It decreases the number of steps a user must take to access an application.

Commonly, Remember Me is implemented by storing an **auth cookie with a long expiry date**. This cookie is sent to the application on each request, where it gets verified in place of a username and password. If the auth cookie is valid, a short lived session cookie is generated to authenticate web requests during that use of the application. If the authentication cookie is not valid, a user is redirected to the login form.

Although users prefer not to re-authenticate, they often **forget to check the Remember Me checkbox**, or they stick with defaults ([The Power of defaults](https://web.archive.org/web/20180319004539/https://www.nngroup.com/articles/the-power-of-defaults/)). To address this issue, some applications check the Remember Me checkbox by default hoping to improve UX.

From a security standpoint, having **Remember Me enabled by default can introduce threats** to the users. Suppose a user logs into an application from a **public computer or a friends device**. She logs in in, and the long lived auth cookie value is set in the browser. If she forgets to logout, or her attempts to logout fails (e.g. networking issues), then having a **long lived auth cookie on the computer opens her account to compromise**. It would be trivial for a curious friend or an attacker to extract the cookie value and get an unauthorised access to her account.

The problem does not stop here. Some UX experts suggest that **opt-in by default is a not a good design**. They consider it as a [**dark pattern**](https://web.archive.org/web/20180319004539/http://www.uxbooth.com/articles/using-dark-patterns-for-good/).

Overall, from both UX and security perspective having **Remember Me enabled by default is a bad design**, so, **please just don't do it!** I have listed a few recommendations if you are planning to give your users a way to have prolonged access to your application.

## Recommendations

### Rethink the necessity of having Remember Me feature

**Remember Me is an insecure feature** for an application. Especially if the application handles **sensitive data** (e.g. finance data, personal details etc.).

#### Pros

- **This is the most secure option**

#### Cons

- User inconvenience of re-entering the credentials
- User may fall victim of phishing attacks as a result of becoming too comfortable entering login credentials every time they use the application

### Educate users to use password managers

**Encourage users to use a password manager** (See [HowToGeek](https://web.archive.org/web/20180319004539/http://www.howtogeek.com/141500/why-you-should-use-a-password-manager-and-how-to-get-started/)). Password managers can automatically fill in the login fields and also solve a lot of other security problems

#### Pros

- Login fields is **automatically populated**
- A **secure method** for users to store passwords locally
- Helps users to **choose strong passwords**
- Users do not need to memorise their password
- **Decrease success rate of phishing attacks**

#### Cons

- Dependency on the security provided by an external application.
- Some users might be unfamiliar with a password manager.
- A user has setup the password manager on a single device and cannot access her account on her other devices.

### Use browser's password manager and set expiry on the passwords

Let browsers **auto-complete feature** fill in the username and password fields but make sure to **enforce password expiry**. Most modern browsers utilise the OS secure APIs to store the password (See [How FireFox store passwords](https://web.archive.org/web/20180319004539/https://support.mozilla.org/en-US/questions/1084997), and [Chrome password manager](https://web.archive.org/web/20180319004539/http://security.stackexchange.com/questions/40884/is-saving-passwords-in-chrome-as-safe-as-using-lastpass-if-you-leave-it-signed-i)) Firefox also allows to encrypt passwords using a **master password**.

#### Pros

- An **additional layer of security** provided by OS
- Credentials are **not stored in the cleartext**
- Credentials can be **encrypted using a master password**

#### Cons

- Dependency on the browser security.
- Browser can be out of date and vulnerable to password leakages
- Storing users password locally has a potential for password compromise
- It is an opt-in feature and needs users approval

Some may argue that letting the browser to store the password is as risky as storing long lived auth cookie. While this is true, we should remember that the **password stored in the browser has an additional level of protection** and it is **not stored in cleartext like cookies**. Even if the password gets compromised, the password is only valid for a limited time and it will be reset.

### And if none of the above recommendations works for you

**Do not enable Remember Me by default**. Implement a [**Security Challenge**](/blog/ux-vs-security-security-challenge) to perform an additional check on the authentication request. For example, if the request comes from an **unknown IP geolocation**, the request should be [blocked](https://web.archive.org/web/20180319004539/https://apple.stackexchange.com/questions/166732/blocked-sign-in-attempt-to-google-account) and user should be prompted for a Security Challenge. Display **list of authenticated sessions** that user have from different devices and ask users to verify and de-authenticate them.

Lastly, **notify user** for her:

- **Last login date and time** in the format of how many past days (e.g. 2 days and 5 hours ago),
- **IP Geo location** and
- **Device type**.

## 7 tips for secure implementation of Remember Me

I have frequently seen Remember Me functionality **implemented insecurely**. Below are some factors that you should consider when implementing this feature. I have extracted them from [this great article](https://web.archive.org/web/20180319004539/https://paragonie.com/blog/2015/04/secure-authentication-php-with-long-term-persistence#title.2):

1. The auth cookie value should be made up of a **number identifier that is random and not-guessable** and a **secure hash** of an auto-generated authentication token.
2. A number identifier is used to **lookup the row in the database table** and prevents the denial-of-service attack.
3. **Do not use username as an identifier** otherwise you facilitate online password brute-force attempts.
4. The auth cookie is **only used to generate a fresh session cookie**. The session cookie is used for authentication of requests.
5. After login, **refresh the auth cookie** and remove the previous token from database session tables.
6. **Set an expiry date** on the auth token in the database and cookie (e.g. 30days).
7. **Never trust the auth cookie expiration date** as it can be easily modified by the client.

That is all. If you have any better idea to manage a Remember Me cookie, post it as a comment.

Ciao
