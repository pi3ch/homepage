---
date: '2015-04-01T10:00:00+10:00'
title: '5 effective use-cases of a honeypot system for enterprises'
draft: false
tags: ["security", "honeypot", "enterprise", "active defense", "usecases"]
---

Honeypot systems have been around for more than a decade. There have been a number of initiatives such as The Honeynet Project or Project Honeypot that have had a great impact on development and adaption of honeypot systems.

However, within enterprises, honeypot systems have not been widely adapted or used. This could be due to difficulty in setting up and managing a honeypot system as well as not knowing their invaluable benefits. The focus of this article is to highlight 5 effective use-cases of a honeypot system for any enterprise.

# 1. Blacklisting – keep attackers out and save resources for users

A honeypot system is located in an area where there are in no-use for a real user. This means the traffic received by an external facing honeypot system (that is setup within business DMZ infrastructure) is considered as suspicious. **The source addresses of these suspicious traffic can be feed into security devices to block intruders' access at the edge of the network**.

This keeps those attackers away from accessing servers and saves the server resources (e.g. bandwidth, componential usage, etc) for the legitimate usages.

OpenBL, BlockList.de, DRG insight are a few public and generic blacklists that populated by honeypot systems deployed in various networks.

# 2. A complimentary system to IDS/IPS – keep the false-positive alerts to a minimum

An Intrusion Detection System (IDS) or Intrusion Prevention System (IPS) typically generate lots of alerts that require a manual human verification. Fundamentally, these systems are looking at network data to classify the traffic. Therefore, with this limited view, there are a lot of gray areas that it is impossible to classify a traffic as malicious or otherwise. **A honeypot system can be a great addition to an IDS/IPS system by gathering more intelligence about the intruder and provide a feed to these system for better automated classification of the network traffic**. For example, upon observing a suspicious traffic, an IDS redirects the traffic to the honeypot system (and keeps attacker away from a real server).

This keeps the server protected from a potential attack and at the same time gathers more intelligence about a potential intruder that greatly enhance an automated detection.

# 3. Discover an internal compromised host or a malicious insider

A honeypot system can be deployed in a strategic network subnet mimicking a genuine host. If an internal host gets compromised and the host is used to do **reconnaissance on the internal network**, this internal honeypot is a best system to identify these activities. The reconnaissance task is the first and fundamental step an attacker does to proceed with a compromise. This task is difficult to be picked up by security devices as it can be very similar to the normal network traffic.

# 4. Attack intelligence feed to a SIEM software

More companies are adapting Security Information and Event Management (SIEM) software to have better overview of security events. A custom honeypot system that is deployed within the business network (internal or external facing) can provide **an invaluable attack intelligence feed** to these software. It provides a picture of what attacks are being targeted at the business and what their purposes are.

# 5. Increase the cost of attack – disrupt an attack chain

A honeypot system by its nature makes it difficult for an attacker to be successful in his/her attack chain. An intelligently and custom build honeypot system indirectly increases the cost of attack (time and effort wise) and potentially makes a successful compromise uneconomical from an adversary perspective. For example, **an attacker must put more time and effort to detect if the system they are targeting is real**.

This use-case of honeypot system is classified as active defence technique that indirectly protects the business systems.

There are a number of other use-cases for a honeypot system within organisations. If you can think of any other use-cases, you can share them within the comment section. In another article we will talk about the other barrier in adapting a honeypot system i.e. the difficulties in creating and managing a honeypot system.
