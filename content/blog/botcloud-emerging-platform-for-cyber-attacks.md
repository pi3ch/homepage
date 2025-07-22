---
date: '2012-10-29T10:32:00+10:00'
title: 'botCloud – an emerging platform for cyber-attacks'
draft: false
tags: ["security", "cloud", "research", "botnet", "botcloud"]
cover:
  image: "/blog/images/botcloud_experiment_framework.png"
---

_This article was originally published on [Stratsec Blog](https://stratsec.blogspot.com/2012/10/botcloud-emerging-platform-for-cyber.html)_

Hosting network services on Cloud platforms is getting more and more popular. It is not in the scope of this article to elaborate the advantage of using Cloud computing, instead, as the title of might have already inspired you, here we discuss the potential benefits available to malicious entities in using a Cloud platform (CP). In particular, we are going to see:
- What benefits do attackers get by using CP for their nefarious purposes?
- Can a CP be programmed to launch security attacks, propagate malware, or perform denial-of-service attacks?
- Are the current security features of CP providers robust in their detection and prevention of malicious usage?

The questions above were based a research study conducted at the Stratsec IT Security Winter School 2012. The objective of this research was to investigate the security posture of Cloud providers in protecting against malicious usage (the security point of view), as well as assessing the effectiveness of such CPs for launching malicious activities (the attacker point of view). We define "botCloud" as a group of Cloud instances that are commanded and controlled by a malicious entity to initiate cyber-attacks.

## Setup

The research was initiated by subscribing to five common Cloud providers and setting up to 10 Cloud instances (virtual machines) at each provider to form the attacker hosts. The target (victim) hosts were setup virtually in a controlled network environment. A public IP address as well as a DNS name was associated to each of victim hosts where the traffic from attacker hosts could be directed. All network traffic from the attacker was monitored and recorded. Each victim host was equipped with typical public network services such as Web, FTP and SMTP.

One of the main questions was to identify the type and nature of tests that we could run on each attacker host against the victim hosts. We selected a set of test cases that are commonly used by security professionals to benchmark security systems. These test cases included:
- **Malformed traffic**: Sending a series of non-RFC compliant packets, as well as aggressive port scanning.
- **Malware traffic**: Sending a set of publicly known and commonly detected malware to the victim host via a 'reverse shell'.
- **Denial of service**: Sending a flood of traffic to a web server on the victim host.
- **Brute force**: Attempting to brute-force the password for the credentials on the FTP service.
- **Shellcode**: Launching a set of known shellcodes against various services running on the victim host.
- **Web application**: Launching commonly known web application attacks against the victim host including SQL injection, cross-site scripting, path traversal, etc.

In order to further verify that the test cases were detectable by the security systems, we setup an off-the-shelf intrusion detection system (IDS) with its default configuration on the victim host. The IDS was set to monitor all network traffic sent to and received from the attack hosts, and to log and alert on possible incidents.

## Experiment

We conducted the four experiments listed below, based on the duration of running each test case and location of the victim host. The description of each experiment is as flow.

- **Experiment 1**: The victim host was placed in a typical network environment with a public IP address, firewall and IDS. The test cases were executed on each of the attack hosts all targeting the single victim host. The purpose here was to investigate the security posture of CPs in the event of outbound "malicious" traffic.
- **Experiment 2**: The victim host was setup as a Cloud instance (instead of a host in a local environment). Using the internal network connection amongst Cloud instances, the test cases were launch against the victim host. The purpose here was to benchmark the security posture of CPs when the traffic transmitted within Cloud's internal network instances.
- **Experiment 3**: With a similar setup to the previous experiment, we executed the test cases on the Cloud platform other than the one running the victim host. The idea here was to investigate the security of CPs when the traffic comes from an external network.
- **Experiment 4**: With a similar setup to experiment 1, we increased the duration of the test cases execution. We selected some of test cases (e.g. full TCP handshake port scanning) and execute them for nearly 48 hours. The idea here was to investigate if duration of the test case execution and the volume of the generated traffic can cause impact on the result of the experiment.

Figure 1 illustrates the conceptual framework of the experiment. The Cloud instances and Test server are respectively attacker and victim hosts. We used Monitoring and Command and control hosts to monitor network traffics and send commands to Cloud instances.

![Figure 1: the experiment conceptual framework](/blog/images/botcloud_experiment_framework.png)

The experiment was conducted over a period of 21 days. We measured the CPU and network bandwidth usages of each attack host using both the CP's API and a monitoring program running on each host. Additionally, we captured and recorded the generated network traffic.

## Results and observation

The below illustrates the result of the experiment from two perspectives – the security posture of CPs, and the benefits for malicious entities.

### Security posture of the Cloud platforms

During the execution of the test cases, although we were expecting responses from Cloud providers, our observations on the five tested Cloud providers showed that:
- No connection reset or connection termination on the outbound or inbound network traffic;
- No connection reset or termination against the internal malicious traffic;
- No traffic was throttled or rate limited;
- No warning emails, alerts, or phone calls were generated by the Cloud providers, with no temporary or permanent account suspensions;
- Only one Cloud provider by default blocked inbound and outbound traffic on SSH, FTP and SMTP, however these limitation was bypassed by running the above service on non-default port.

### Benefit for malicious entities

From the perspective of a malicious entity using the Cloud as an attack platform has potentially the following benefits:
- **Relatively easy to setup and use**: compared with a traditional botnet setup where an attacker generally requires extensive knowledge about programming languages, software vulnerabilities and networking, it is relatively easy to setup a botCloud. Here, attackers require familiarisation with the CPs API as well as system administration knowledge.
- **Significantly less time to build**: in a typical botnet setup an attacker must find a list of victims, bypass the victim's security systems (e.g. anti-virus, anti-spam filter) to propagate malware, and then hope for execution of the malware on the victim's machine in order to turn it into a zombie box. In a botCloud setup, it takes a matter of minutes to create a large number of clones of a Cloud instance. This makes it virtually effortless to create tens to hundreds of cloned instances in which to launch attacks from.
- **Highly reliable and scalable**: scalability and reliability are the two important factors that have attracted lots of organisation to the Cloud. Given this appeal, they can also give attackers a more stable platform for launching attacks. This can be compared with traditional botnets where a zombie boxes might become unresponsive or be taken offline completely.
- **More effective**: attackers can fully utilise the fast CPUs and network infrastructure on the Cloud instances where in the case of a traditional botnets, the attacker is limited to the resources available on the zombie boxes.
- **Low cost**: base on our experiment, with the budget of as low as $7 and minimum hardware specification, it is possible to setup a botCloud with tens to hundreds of Cloud instances. Figure 2 illustrates the CPU and outbound network usage for the first experiment on one of the Cloud providers. The average CPU usage (dotted line) is less than 20% and the network outbound traffic less than 0.2 megabytes (1.5 megabits). This figure shows that the volume of resources required for running a botCloud can be relatively low, depends on type of attack.

![Figure 2: CPU and outbound network bandwidth usage for the first experiment on one of the Cloud providers](/blog/images/botcloud_cpu_network_usage.png)

## Conclusion

The research investigated the security posture of Cloud platforms against malicious usage, as well as the effectiveness of setting up a botCloud using this infrastructure. We define "botCloud" as a group of Cloud instances that are commanded and controlled by malicious entity to initiate cyber-security attacks. A set of common test benchmarks were executed on platforms run on five public Cloud providers against a set of test servers. The results of the experiment showed that no connections were reset or terminated when transmitting inbound and outbound malicious traffic, no alerts were raised to the owner of the accounts, and no restrictions were placed on the Cloud instances.

From malicious entity's point of view, the botCloud was relatively easy to setup; requiring significantly less time to build, and considered highly reliable when compare to a traditional botnet. Furthermore, the resource consumption for running a botCloud was found to be relatively low and can potentially be setup with a limited budget.

For organisations that are seeking to host their services on the cloud, if you have a mature technical security capability with your on-site solutions, you may find higher likelihood of compromise, reduced likelihood of notification attack and possible difficulties in investigation and response when you move toward Cloud hosted services. The following are quick words of advice if your organisation is moving to Cloud computing:
- Look for security features such as high-end firewall and IDS when you choosing a Cloud provider.
- Does the Cloud provider undertake regular security testing of their environment? If so is this done independently? Can you validate them to see if they meet your expectations? Be diligent in your investigations and consider how the Cloud provider's security model fits with your enterprise security architecture.
- Think about services you are planning to host on the Cloud. Do not get temped with ease of use and cheap cost.
- Be aware of a possible botCloud attack. The traffic that is coming from public Cloud providers should not necessary be deemed safe.
