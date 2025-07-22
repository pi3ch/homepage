---
date: '2015-04-21T10:00:00+10:00'
title: 'What active defence is and is not'
draft: false
tags: ["security", "active defense", "honeypot", "attack chain"]
cover:
  image: "/blog/images/active_defence.jpg"
---

Active defence (or active defense) is relatively a new approach within IT security field. There have been some efforts to define this term. However, the majority of these definitions are incomplete, unspecific, or missing essential attributes of this security approach. Some even **mixed up** active defence approach with offensive security techniques.

The purpose of this article is to describe key attributes of active defence and highlight what this approach is about and what it is not about.

# Active defence is not about hack the hackers or hacking back

"Hack the hackers" although being a phrase interested by press, it is nothing to do with active defence. The techniques such as eliminating attackers' command and control (C&C) server or attempting to penetrate to attackers infrastructure by exploiting vulnerabilities are well categorised within the offensive security domain. **Active defence is not about using an offensive technique to eliminate source of the attack.** It is worth mentioning that usage of offensive techniques have also raised legal concerns with the community.

# Active defence is about increasing the cost of attack

**Active defence is a security approach that actively increases the cost of performing an attack in terms of time, effort and required resources to the point where a successful compromise against a target is impossible**. This approach is about profiling an attack chain, identifying different stages of attack, and using defensive security controls to disturb the follow of attack. Inevitably, to increase the cost of attack, an active understanding of the attack chain is required.

# Active defence vs traditional security

In the traditional security approaches, higher premier walls are made to make it difficult for an intruder to enter. However, **once an intruder is inside, there is almost nothing to stop his progress**. These approaches has incentivised an attacker to use a lot of resources to be able to overcome the barrier as once they passed it, there is a high chance that there is nothing to stop him further. A real-world example of this is a huge volume of online password brute-force attempts that are being conducted at scale of Internet. Attackers are willing to accept the 'significant' cost of running the infrastructure for large-scale brute-force attempts because they know once they correctly guessed a credential, it is easy to further compromise the host and use it for their purposes.

Focusing on this example, within active defence domain, we take one step back by first monitoring how a real compromise via password brute-force looks like. **We observe what other steps an attacker needs to take in other to compromise a system. Additionally, we discover what the purpose of the attack is**. Having this attack intelligence, we place effective security controls (authentication delay, directory permissions, proxy outbound traffic etc.) at different stages of an attack chain in order to make it more costly (or impossible) for an attacker to progress.

# Active defence is not new

This is not a first time security industry uses this approach to protect data or systems. For example, **the idea of adoptive hash function is to increase complexity of a hash and make it resistant to offline password cracking as computational power increases over the time**. In other word, we actively increase the complexity and cost of successful password crack. Clearly, other techniques to protect a user password have failed to achieve their mission therefore, security community needs to find an alternative way to make an offline password crack difficult, complex and time-consuming to the point where an attacker gives up.

# Honeypot system and active defence

Traditionally, a honeypot system is used for tracking and monitoring an attacker prior and after exploitation. Honeypot system is great tool to gain real-world intelligence on an attack. From another angle, **a honeypot system indirectly increases the cost a successful compromise.** Attacker must spend more time and use more complex technique to discover if a system they interact is real or not. This indirectly put a cost on attacker.

For example, if an attacker managed to get inside a network and tried to scan other vulnerable hosts. Having an internal honeypot system can waste a lot of time for an attacker to target a real system.

# Active defence, a promising way forward

Active defence enables us to think from different perspective when it comes to protecting our assets and minimising risks. It is about the famous quote "**know your enemy**". By first studying the attackers who target our systems, we put in place more robust counter measures to disrupt an attacker mission.

We believe active defence is a great approach for businesses to actively protect their system and effectively respond to attacks.
