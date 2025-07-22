---
date: '2015-11-01T10:00:00+10:00'
title: 'UX vs Security - Security challenge'
draft: false
tags: ["security", "ux", "authentication", "2fa", "login", "user experience"]
---

_This article was originally published on [elttam](https://web.archive.org/web/20180319004657/https://www.elttam.com.au/blog/ux-vs-security-security-challenge/)._

This article is the second in our series on UX vs Security trade-offs and is focused on **UX vulnerabilities in the login process**. I recommend to read [UX vs Security Introduction](/blog/ux-vs-security-introduction/) prior to read this article.

A **security challenge** is an extra verification step that checks the authenticity of an incoming request prior to authorisation of an action. A security challenge can be generic or application specific. Some examples of common security challenges are:

- Email verification
- Security or secret questions
- Verify phone, recovery email or previous login location
- Interactive Voice Response (IVR) or SMS verification
- Second factor authentication (2FA)

An example of the application specific security challenge for a social network is to verify a user by asking her to **identify her connections** in a list of people.

During the login, there are different events in which a security challenge verification is required (see Microsoft account recent activity page for more events):

- Login from a **new IP geolocation**;
- Login from **new browser or device**;
- Change in the **login behaviour**;
- **Simultaneous logins** using the same account; and
- **Excessive failed login attempts**.

A password-based authentication system **does not verify an identity**. All it proves is the requesting person knows the user password combination.

Security challenges **improve the security** of your authentication system by adding an additional layer of user verification and decreasing its reliance on the password. From a security perspective, security challenge verification is becoming a **best-practice** and should be implemented by applications.

The trade-off here is favouring user convenience and not having an additional security check or enforcing a security challenge that adds an extra step to the login process. In the section below, I have listed a number of recommendations for security challenges along with their pros and cons. Your application context, user awareness and Threat Model can help you to choose a best option.

## Recommendations

### Second-factor authentication (2FA)

Implement a **Time-base One-time Password authentication**. One good implementation is Google Authenticator. You can find its [Python implementation here](https://web.archive.org/web/20171226210644/https://www.twilio.com/blog/2013/04/add-two-factor-authentication-to-your-website-with-google-authenticator-and-twilio-sms.html).

#### Pros

- **The most recommended method** (at the time of writing)
- Protects users from known password attacks.
- There are many good libraries available to implement it securely.
- **Secure by design**

#### Cons

- Still a new concept and unfamiliar for some users
- User would temporarily lock herself out by losing access to a second factor.
- Requires implementation of a backup method in case a user permanently lost her access to a second factor.
- Some users keep their browser history fresh or use private browsing mode, these users need to use a second factor every time they want to login.
- Incompatibility with APIs or legacy applications

### IVR or SMS verification

AWS IVR or Phone verification

Implement an **IVR or SMS verification**. Allow a **5 minute time window** for users to enter the verification code. Restart the process if the window passed or the user incorrectly enters the verification code.

Limit the number of verifications to **3 to 5 attempts per half-an-hour**. Once the threshold is passed, apply a temporary account lock-out (e.g. for example for 30 minutes).

#### Pros

- Repurposing a familiar technology
- Users do not need to setup a software or buy an additional hardware
- An **out-of-band verification channel**
- Relatively, more reliable option and is used as a backup method

#### Cons

- Increased cost of using an IVR or a SMS service
- **IVR/SMS protocols are both insecure in design** and can be intercepted
- Depending on the user SIM card provider, it can be trivial to port the user phone number
- Losing the phone number or traveling overseas keeps user out of the system

### Email verification

Implement an **email verification mechanism**. Generate a URL token so a user can click and continue the authentication process. Make sure the user is using the same session when they visit the website using the generated URL. Otherwise, restart the process and prompt for authentication.

The URL token must have **all the following characteristics**:

- **Unique**: a token should be unique per user session,
- **One-time-use**: it can only verify user once,
- **Time-limited**: expires in a short time, e.g. 5 minutes,
- **Random**: generated from a secure pseudo-random generator, and
- **Not-guessable**: it should be minimum 128 bits long and do not contain dictionary words or a known pattern.

Limit the number of verifications to **3 to 5 attempts per half-an-hour**. Once the threshold is passed, apply a temporary account lock-out.

#### Pros

- Comparatively, it is convenient for a user to do email verification

#### Cons

- **Email is insecure by design** and can be intercepted.
- By regularly sending email verification messages to users, we **create the user expectation** of receiving emails for authentication purposes. This increases the threats of spear-phishing attacks against our users as a user expects to receive such emails and clicks on the links.
- User may have lost their access to the email account or forgot which email she has used.

### Security questions

A security question should have the following [four characteristics](https://web.archive.org/web/20180319004657/https://www.owasp.org/index.php/Choosing_and_Using_Security_Questions_Cheat_Sheet):

- Easy to remember
- Do not change over the time
- Applicable to wide range of users and backgrounds
- Not easily guessed or researched

**Do not allow user to create their own security questions**, as they may choose a canned or an insecure one. Create a **time window of 10 minutes** for the user to answer the question. Once the window is passed or an incorrect answer was given, restart the process and prompt her for login.

**Rotate security questions** on each login attempt. If all questions are prompted with no correct answers, temporarily lock the user account.

A user can be asked to verify a user phone number, recovery email address or previous login location in addition to one of the security questions.

#### Pros

- Simple to implement
- No dependency on other platforms

#### Cons

- **There is no good security question, only bad (or fair) questions**.
- [A study shows that large number of users unable to recall their answers or provide fake but easy to guess answers](https://web.archive.org/web/20181222004928/https://ai.google/research/pubs/pub43783).
- Users social profile assist an attacker to guess the answer to a security question.
- **Poor security questions provide no additional security**
- The more websites use security question, the more chance a user uses the same security question and answer.
- Open to brute-forced attempts

### And if you cannot implement any of these recommendations, at minimum

Ask the user to **verify her phone number, recovery email address or previous login location**. Notify user for suspicious events such as login from unknown locations or unknown devices, excessive failed login attempts, and simultaneous login using the same account. The notification can assist user for **early detection** of malicious attempts.

## And how about UX, you asked?

Consider implementing the following tips along with your selected option:

- **Educate your users** on the benefits of a security challenge e.g. [a good example from Google](https://web.archive.org/web/20180319004657/https://www.google.com.au/landing/2step/) and [a bad example from Linkedin](https://web.archive.org/web/20190604021356/https://www.linkedin.com/help/linkedin/answer/3065?lang=en). When a user understands the benefits, she is more willing to accept the inconvenience of taking the extra steps.
- Give the user **step-by-step instruction** on how to respond to a malicious attempt e.g. [an example from Google](https://web.archive.org/web/20180319004657/https://support.google.com/accounts/answer/6063333?hl=en).
- **Whitelist user IP address and device type** for a month and do not prompt the user for a security challenge during this period. The whitelisting is commonly implemented using Cookies.
- **Notify user** for non-whitelisted authentication attempts.

Before I finish, I should say that I could not find exact study to support thresholds such as **30 minutes account lock-out** or **10 minute verification time-windows**. You may want to increase or decrease them however, if you allow a longer verification window you give more chance to an attacker to succeed.

In the next article I discuss about UX vs. security trade-off in enabling Remember Me by default.
