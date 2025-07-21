---
date: '2012-11-03T10:00:00+10:00'
title: 'botCloud - a command and control platform on the Cloud'
draft: false
tags: ["security", "cloud", "research", "botnet"]
---

My recent write-up on a summary of the research experiment ([botCloud](http://stratsec.blogspot.com.au/2012/10/botcloud-emerging-platform-for-cyber.html)) has got interesting international coverage. Here is quick responses to some of the comments:

> "Computing is becoming cheaper and cheaper and for something like $10 one can buy enough computing power to take down a small website for a few hours," Costin Raiu, director of the Global Research & Analysis Team at antivirus vendor Kaspersky Lab, said Tuesday via email. "However, it's also important to say that 'traditional' methods of infecting users with trojans are probably even cheaper and much more resilient to takedowns." -- [CIO](https://web.archive.org/web/20140122213729/http://www.cio.com/article/720276/Lack_of_Abuse_Detection_Allows_Cloud_Computing_Instances_to_Be_Used_Like_Botnets_Study_Says)

In the 'traditional' botnets, the setup cost - identifying victims, bypassing security systems and hoping for execution of malware on a user's box - is relatively higher. The cost of platform's reliability is another factor that can potentially increase the overall figure.

> "It takes a lot of time to find a user which is infected by something like a bot from the Pandora DDoS family and convince him to clean his PC," Raiu said. "Such infections can last for weeks or for months - making them a lot cheaper than cloud computing solutions." -- [Computer World](https://web.archive.org/web/20211130183249/https://www2.computerworld.com.au/article/440522/lack_abuse_detection_allows_cloud_computing_instances_used_like_botnets_study_says/)

Lets talk about zero-days here. No mater it is a PC or a cloud instance it could be hard to detect such infection in both cases. Given the access level available for a malicious entity in the cloud compare with a zombie PC, they have better chance of hiding infections and using the platform for a longer period.

> David Harley, a senior research fellow at antivirus vendor ESET, said Tuesday via email. "I can't comment on how typical these providers were. However, when and where cloud providers do implement such countermeasures, the overheads for developing a resilient malicious network are likely to increase sharply." -- [Tech World](https://web.archive.org/web/20130621092603/http://news.techworld.com/security/3408223/failure-detect-abuse-allows-cloud-computing-instances-be-used-like-botnets/)

As this concept as well as Cloud computing itself is relatively new to the market, the challenge nowadays is to design such countermeasures. Developing and implementing a countermeasure framework that can well operate in such large-scale situation is still a hot research topic.
