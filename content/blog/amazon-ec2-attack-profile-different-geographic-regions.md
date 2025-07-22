---
date: '2014-12-18T10:00:00+10:00'
title: 'Your Amazon EC2 attack profile changes on different geographic region'
draft: false
tags: ["security", "cloud", "aws", "ec2", "honeypot", "research"]
cover:
  image: '/blog/images/ec2_attack_profile_zones.png'
---

# Summary

The experiment highlights the correlation among sources and types of attacks across Amazon EC2 geographic zones (or regions) by using Smart Honeypots. The purpose is to identify whether choice of EC2 geographic region has an impact on risk profile of a Cloud-based host.
- With only 6% correlation on source of intrusions, **94% of intruders were unique to each zone**.
- **The attack profile between zones were completely different**. Tokyo zone received significant number of NTP amplification intrusions, where Ireland suffered the most from SNMP scanning and N.Virginia from SSH brute-force attempts.
- **Intruders targeting N.Virginia** were mainly sourced from **Russia and China**, whereas **Sydney** zone received most intrusions from **Netherlands**.
- Except for DNS amplification intrusions that widely observed on all zones, **intruders were only targeted a single zone**.
- **DNS amplification, SSH brute-forcing, VoIP, SNMP and UPNP scanning** had the **highest correlation** across all zones.
- **Ecatel and Firering (NL), OVH (France), Redstation (UK) and VolumeDrive (US)** were top non-Chinese providers that allowed for their environment to be used for **launching attacks**.
- **Read our recommendation on how to improve the security of your cloud instance by getting access to our cloud-based custom blacklist service**.

# Introduction

As part of on going Project Amazon EC2, I investigated the attack profiles across different EC2 geographic zones by using Smart Honeypot (SH). My objective was to make an attack profile for each EC2 zone and identify the correlation between source of intrusions. In particular, I wanted to discover if there is a limited set of IP addresses target EC2 Cloud instances across different geographic zones (which by the end of experiment it ended up being something completely different!).

# Experiment setup

The following list shows details of the experiment:
- **Number of SH Cloud instances**: five (5)
- **Start and end dates**: 13 April to 23 May 2014
- **Duration**: forty (40) days
- **EC2 geographic zones**: Tokyo, Sao Paulo, North Virginia, Sydney and Ireland
- **Cloud instance base image**: Ubuntu 13.04 – EC2 micro instance
- **IP addressing**: Default IP address block per each EC2 zone

The AWS firewall was set to allow all the inbound connections so SH can observe and respond to all network traffics.

**No domain names were mapped to SH public IP addresses and their addresses were not disclosed or advertised anywhere.** Moreover, **SHs across EC2 zones were all identical**.

# Observation

## There was almost no correlation!

In total, **1927 unique IP addresses were collected during the experiment**. **Surprisingly there was only 6% correlation across different zones** which means over 94% of threat actors were unique for each zone.

## Correlation of intrusions

The following intrusion were targeted on all the SHs:
- DNS Amplification Attack (53/udp)
- SSH password brute-force attempts (22/tcp)
- Sipvicious Scan (5060/tcp)
- SNMP scan (161/udp)
- UPnP service discovery (1900/udp)

## China, USA and Netherlands top origin of intrusions

Figure 1 illustrates countries where intrusions were originated. **China, USA and Netherlands were on top three (3) countries**. The interesting observation here was DNS amplification intrusions that were mainly originated from Netherlands IP addresses.

![Figure 1 – Origin of intrusions on EC2](/blog/images/ec2_attack_origin_countries.png)

## Chinanet, Ecatel and OVH providers with weak security

Below list details which provider involved in the majority of intrusions across all SHs
- **Chinanet Backbone**, China, ASN 4134
- **Ecatel** hosting provider, http://www.ecatel.info, Netherlands, ASN 29073
- **OVH**, http://www.ovh.com/, France, OVH 16276
- **Fiberring** networks, http://www.fiberring.com/, Netherlands, ASN 16265
- **Redstation** hosting provider, http://www.redstation.com/, UK, ASN 35662
- **VolumeDrive** hosting provider, http://volumedrive.com/, USA, ASN 46664

The weak security posture of these providers facilitated the execution of the majority of intrusions that were observed by SHs.

## EC2 attack profile per each zone

Figure 2 illustrates number of intrusions per each SH. Tokyo SH received the most amount of intrusions following with N. Virginia and Ireland SHs. April 13 to April 17 showed large number of attempts on all SH. On April 25th there was a network connectivity issues with the data aggregator cluster servers and I didn't collect the data for that day (it is a real world experiment and these things happens!).

![Figure 2 – Attack profile per each EC2 geographic zone](/blog/images/ec2_attack_profile_zones.png)

For the remaining part of this section, I summerise SH's attack profile per each EC2 zones. **By only glancing over zone figures, you can see each SH have completely different attack trend**. Before getting into the details, I should also remind the following note:

_The reader should be reminded that the country and ownership information were collected only by looking at the registration information (i.e. whois) of the intruder IP address and it should not perceived as the intrusions are orchestrated by a particular nation. A computer savvy person is aware of the fact that source IP addresses can be easily spoofed._

### Tokyo

Figure 3 shows a trend of intrusions and targeted network services on Tokyo SH.

![Figure 3 – EC2 Tokyo zone attack profile](/blog/images/ec2_attack_tokyo.png)

#### NTP amplification and Tor-originated intrusions

**There was significant amount of NTP amplification intrusions targeting Tokyo SH**. The attempts were steady for over a month with average of 40 attempts per day.

The majority of NTP amplification intrusions attempts were **originated from Tor exit nodes**.

Top intruder was 219.117.206.46, sylph.white-void.net owned by Interlink Co.

### N. Virginia

Figure 4 shows a trend of intrusions and targeted network services on N. Virginia SH.

![Figure 4 – EC2 N.Virginia zone attack profile](/blog/images/ec2_attack_virginia.png)

#### Chinese and Russians IPs were behind most intrusions

SSH brute-forcing attempt was dominant on N. Virginia SH. In particular it increased toward the end of the experiment. The majority of the attempts was sourced from 116.10.191.1/24 (e.g. 116.10.191.226, 116.10.191.190, 116.10.191.187, 116.10.191.231) subnet that owned by Guangxi data comm.Bureu, China, ASN 12695. Interestingly there was no intrusion from this subnet on other SHs.

SIP scan was sourced from 95.163.121.1/24 (e.g. 95.163.121.175, 95.163.121.173, 95.163.121.17, 95.163.121.165) owned by Digital Network JSC, http://www.msm.ru, Russia, ASN 35662. Similarly to SSH brute-forcing there was no intrusion observed from this subnet on other SHs.

93.180.5.26 was among many other intruders conducting a wide DNS amplification intrusions. The intrusions from this source was also recorded on other SHs. The IP address belongs to Moscow State University, Russia, ASN 2848. The intruder host found to have port 22, 80 and 443 open. Throughout the experiment the host's SSH service banner changed from _OpenSSH 5.3 protocol 2.0_ to _OpenSSH 6.6p1-hpn14v4 protocol 2.0_.

50.202.126.166 (50-202-126-166-static.hfc.comcastbusiness.net) owned by Comcast Cable Communications (http://business.comcast.com/) performed a large number of SNMP probing on N. Virginia SH.

Vulnerable versions of PHPMyAdmin were constantly accessed by 202.202.113.159 (Chinese Southwestern Agricultural University). Surprisingly, there was no attempt to exploit these vulnerabilities.

### Ireland

Figure 5 shows a trend of intrusions and targeted network services on Ireland SH.

![Figure 5 – EC2 Ireland zone attack profile](/blog/images/ec2_attack_ireland.png)

#### Shodan scan bots and JSP CMS

Ireland SH received large number of SNMP fingerprinting attempts from 5.254.105.110 (lh26042.voxility.net) owned by Voxility cloud provider, https://www.voxility.com, USA. This intruder was also found to target Sydney SH.

93.180.5.26 that was previously mentioned found to conduct DNS amplification, SNMP and UPNP scanning on the SH. The intruder started with DNS amplification attack and move to SNMP scanning toward end of April and at beginning of May UPNP scanning were conducted concurrently with other intrusions.

Shodan scan bot (http://www.shodanhq.com) were found to probe for uncommon ports such as 32764, 20000, 27017, 9981, 7777, 7071 etc. **These ports seem to be related to Internet connected devices** (e.g. IPTV, Webcam, etc.).

A number of attempts from 94.177.121.102 (host-122-102.optic-bridge.net) and 184.154.150.120 (lardnerserver.datahop.com) targeting JSP CMSes were observed on Ireland SH (as well as Sydney and Tokyo SHs). In some instances, attackers browsed to known JSP-shell paths on the server (i.e. /cmd/cmd.jsp). A sample list of requested URLs are provided below. The behaviour from both IP addresses were identical showing possibility of a single threat actor behind these reconnaissance activities:

```/dev/null/jsp-cms-paths.txt#L1-11
/web-console/ServerInfo.jsp
/jmx-console/HtmlAdaptor
/dawdwadwaad
/zecmd/zecmd.jsp
/safe2/index.jsp
/manager/html
/man/3.jsp
/iesvc/iesvc.jsp
/cmd/cmd.jsp
/DnSjEgA/
```

### Sydney

Figure 6 shows a trend of intrusions and targeted network services on Sydney SH.

![Figure 6 – EC2 Sydney zone attack profile](/blog/images/ec2_attack_sydney.png)

#### Elcatel a hosting provider in Netherlands behind most intrusions

Probing and connection to RDP (Remote Desktop Protocol) was noticeable on Sydney SH. The majority of attempts sourced from 58.218.205.158 and 117.21.250.233 owned by Chinanet, China, ASN 23650 following by 54.187.32.79 owned by Amazon, US.

46.165.220.215 by Fiberring, Netherlands, 37.0.124.131 by LeaseWeb, Netherlands, and 115.168.71.84 by ScopeHosts, India were top three intruders for SIP scans.

80.82.78.105 and 94.102.51.229 by Ecatel, Netherlands, ASN 29073 following with 178.32.56.245, OVH, France were orchestrated the majority of DNS amplification intrusions not only on Sydney but also on other SHs.

SNMP scan found mainly source from ShadowServer's scan bots (http://www.shadowserver.org).

### Sao Paulo

Figure 7 shows a trend of intrusions and targeted network services on Sao Paulo SH.

![Figure 7 – EC2 Sao Paulo zone attack profile](/blog/images/ec2_attack_sao_paulo.png)

#### Large number of HTTP proxy requests and intrusive Shodan bots

Sao Paulo SH received large number of HTTP proxy requests. **It seems like the IP addresses that was assigned by Amazon to this SH were previously (mis)used as a HTTP proxy server** (Providers must quarantine IP addresses for a specific period before assigning them to another customer). A sample list of targeted URLs are listed below where the majority seems to be used for Ad affiliated programs.
- http://ads.yahoo.com/st?ad_type=ad&ad_size=728×90&section=5538321&pub_url=themobileblog.co.uk
- http://www.mmadsgadget.com/t?id=e578caa1-e7a0-8904-11ab-2742b8646898&size=300×250
- http://media.fastclick.net/w/get.media?sid=69519&m=6&tp=8&d=j&t=n&exc=1
- http://ads.reduxmediagroup.com/ttj?id=723100
- http://ads.reduxmediagroup.com/ttj?id=723101
- http://ads.q1media.com/ttj?id=2452209
- http://ib.adnxs.com/ttj?id=2428249
- http://ib.adnxs.com/ttj?id=2428276

Shodan scan bot (http://www.shodanhq.com) were also found very intrusive on this SH looking probing for uncommon ports.

And similar to other SHs, a large number of DNS amplification intrusions sourced from Ecatel, Netherlands, ASN 29073 was observed on Sao Paulo SH.

A considerable increase in the number of SSH brute-forcing attempts toward end of May was prominent on this SH. This was due to two new threat actors i.e. 112.223.45.229 and 110.45.244.147 from South Korea targeting all SHs for root account with guessable password combinations (e.g. qwerty, password, 123456). Both IP addresses sourced from the same ASN 3789. Banner grabbing of the first host advertised the following details:

```/dev/null/banner.txt#L1-3
Port 22: OpenSSH 5.3p1 protocol 1.99
Port 80: Apache httpd 2.2.23 (Unix) mod_ssl/2.2.23 OpenSSL/1.0.0-fips PHP/5.3.22 mod_jk/1.2.37
```

## Other observations

ShadowServer scanning bots were observed requesting for determining the DNS version by using _version.bind_ request.

Shodan scan bots were actively probing for DNS Search Discovery (DNS-SD) enabled DNS server.

scanresearch1.syssec.ruhr-uni-bochum.de and openresolve scanning bots were the other 'legitimate' source IPs behind DNS scans.

**PHP-CGI remote code execution (CVE-2012-1823) was observed on all SHs, deploying variety of malcodes, bitcoin miners, port scanner etc**.

**Tomcat manager brute-force attempts (e.g. /manager/html) were observed on all SHs**. These attempts were mainly sourced from 115.239.248.56 and 122.226.223.83 with a sparse password list (e.g. tomcat, root, admin, manager, s3cret, test, role1, both).

74.207.229.58 (li71-58.members.linode.com) and 192.155.88.57 (li572-57.members.linode.com) both owned by Linode Cloud provider (http://linode.com) targeted all except N.Virgina SHs for Cisco IOS vulnerabilities (http://www.infosecpro.com/penetrationtest/p75.htm). **The request URL was /level/99/exec/show/config**.

The following domain names were target of DNS amplification attempts and the most intrusive threat actors were 93.174.93.178, 89.248.174.31 from Ecatel Netherlands and 178.32.56.245 owned by OVH (http://ovh.net):

```/dev/null/dns-amplification.txt#L1-15
saveroads.ru
zing.zong.co.ua
www.jrdga.info
doc.gov
apews.org
jong.zong.co.ua
shifen.com
a3247.com,
xboot.net,
fkfkfkfc.biz,
magas.bslrpg.com.
hizbullah.me
www.jrdga.info
namecheap.com
1x1.cz (targeted by 199.217.117.165, falcon688.dedicatedpanel.com and 216.155.151.202 , hosted-by.reliablesite.net)
iorr.ru (tageted by 93.174.93.178 and 77.223.136.170, 77-223-136-170.netdirekt.com.tr)
```

# How to protect my EC2 servers?

Harden your server by applying latest patches and secure configuration Below is a list of few recommendations to protect your network service against each widely exploited vulnerability.
- DNS amplification attack mitigation
- NTP amplification attack mitigation
- Hardening SSH service
- Hardening VoIP(SIP)
- Securing SNMP
- Securing UPNP

Patching and keeping services up to date is a difficult task in a long run, specially when due to existence of legacy applications, it is impossible to immediately apply latest security fixes. So what can you do in this situation?

Well, one way is to use a technique known as virtual patching. However, to do this, you first need a working Intrusion Prevention System in place and you need to write a custom rule that block bad traffic and allow for good.

The other interim solution is by using a custom blocklist/blacklist that prevents intruders at the edge of your network (e.g. firewall). In this case, all the traffic generated from a known intruder is dropped and she does not have ability to access your servers. However, the majority of current blacklist feeds are either generic or tailored toward malware or spam campaigns. At the time of writing there are no widely known blacklist feeds that can block intruders targeting cloud platform such as AWS, Google Cloud, Microsoft Azure etc.

**For the first time, we are planing to rule-out a cloud-based custom blacklist service where you can simply use it at your firewall or web server, SSH server, and this feed will block the intruders before they access your server.**
