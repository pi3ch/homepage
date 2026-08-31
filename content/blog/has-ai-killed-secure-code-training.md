---
date: '2026-08-26T10:23:41+10:00'
draft: false
title: 'Has AI Killed Secure Code Training?'
---

![Blog post - Has AI Killed Secure Coding_|690x388](https://discourse-secdim.sgp1.cdn.digitaloceanspaces.com/original/2X/3/3ceea665ae572de770ae1256e3146182f3fe19df.jpeg)

We adopted AI coding tools, our developers ship faster, and the AI already knows the OWASP Top 10. Why are we still paying for secure code training?

It sounds rational. **It is wrong**.

AI has not replaced the need for security expertise in your engineering organisation. It has moved where that expertise is required from writing secure code to reviewing it. That shift sounds small but the data shows it is catastrophic.

## The numbers tell a different story

According to Google's DORA 2025 report, 90% of software development professionals now use AI coding tools, with developers spending a median of two hours per day on AI-assisted work. JetBrains' January 2026 survey puts the figure at 90% as well. Sonar's State of Code 2026 report found that AI now accounts for 42% of all committed code. The expectation is to reach 65% by 2027.

Apiiro tracked more than 7,000 developers across 62,000 enterprise repositories and found that AI-assisted developers produce three to four times more commits than their non-AI peers.

Apiiro's analysis found that monthly security findings in those repositories rose from approximately 1,000 in December 2024 to over 10,000 by June 2025, **a tenfold increase in six months**. 
The nature of the security vulnerabilities shifted too. Although trivial insecure coding pattern errors fell, privilege escalation vulnerability classes jumped by 322%, and security design flaws spiked by 153%.

CodeRabbit's analysis of GitHub pull requests found that AI-generated code carries 1.57 times more security findings per PR than human-written code. Those defects reached the PR stage. They survived whatever review the author performed.

The code is less secure, and it is landing in production.

## The confidence problem is worse than the code problem

Stanford researchers ran a controlled study comparing developers who used AI assistants against those who did not. **Developers using AI wrote significantly less secure code in four out of five tasks**. The researchers also found that those developers rated their insecure solutions as secure.

Sonar 2026 survey found that 96% of developers do not fully trust AI-generated code, however, only 48% review it before committing and out of those who review it, they miss security vulnerabilities.

What this research tells us is that the verification habit is breaking down and the consequences compound at AI-scale output.

## Asking AI to fix AI makes it worse

Most organisations assume the fix is iteration. If the first AI output is flawed, ask the model to improve it. Ask again. Keep refining.

A peer-reviewed study measured exactly what happens when you do this. Across 400 code samples and 40 rounds of AI-driven "improvements", they found a 37.6% increase in critical vulnerabilities after just five iterations. The vulnerability count rose from 2.1 per sample in early iterations to 6.2 by iterations eight through ten.

**The assumption that iterative AI refinement improves code security is false**. In practice, each refinement pass introduces new attack surface. The researchers concluded that "robust human validation between LLM iterations" is essential to prevent new vulnerabilities from being introduced with each pass.

Letting the AI fix the AI does not converge on security. It drifts away from it.

## AI Scanners don't replace judgment

For years, the instinct has been to reach for a better tool. If AI is introducing vulnerabilities, add a SAST scanner. Add dependency scanning. Automate the security review.

The evidence does not support this as a sufficient response.

A 2026 formal verification study found that six industry-standard static analysis tools, evaluated in combination, flagged only 7.6% of formally proven vulnerabilities. They missed 97.8% of confirmed flaws. IOActive's April 2026 study across 27 models, 730 prompts, and 27 programming languages found that nearly one third of AI-generated code samples were fully exploitable despite tooling being available to catch common patterns.

Tools reduce noise. They do not replace judgment. The flaws that survive SAST scans are structural — logic errors, trust boundary violations, access control failures, architectural decisions that look correct in isolation and are dangerous in context. These require a human who understands what secure design looks like and why.

## The security expert in the loop is now load-bearing

The security community has long understood the principle of human-in-the-loop validation for high-stakes decisions. In AI-assisted software development, this is not a nice-to-have. It is a must.

The skill that matters now is not writing secure code from scratch. It is reading AI output and knowing what is wrong. It is identifying a subtle authorisation flaw in a function that passes every automated check. It is recognising that a refactored authentication flow silently changed a trust boundary. It is catching the kind of privilege escalation that jumped 322% in Apiiro's enterprise data and understanding why it was introduced.

Sonar's own 2026 survey named "reviewing and validating AI-generated code" as the number one most important skill for the AI era. The industry has identified the gap. Most organisations have not yet invested in closing it.

## Three takeaways

This is not an argument for slowing down AI adoption. The question is whether your security posture is scaling at the same rate as your development velocity. Based on the data, for most organisations, it is not.

Here are three recommendations:

**Measure the gap.** If you have adopted AI coding tools but have not measured the change in your security finding rate, you are operating blind. Instrument your repositories. Establish a pre-AI and post-AI baseline. 

**Train for the AI security code review.** General secure code training was built for a different era. The skill your developers need now is AI code review — reading generated output with security intent, identifying security design flaws, and understanding how AI reproduces vulnerabilities. This requires hands-on, scenario-based practice against realistic code, not videos and compliance checkboxes.

**Build human review into your AI workflow.** The IEEE-ISTAS 2025 research shows that human validation between iterations is what prevents security degradation in AI-assisted development. If your CI/CD pipeline does not include a mandatory manual security review step for AI-generated code, you have a structural gap.

## Conclusion
AI has shifted the threat surface from code generation to code review. Your developers are the last checkpoint before vulnerable code reaches production. The question is whether they have the skills to hold that line.

The question "has AI killed secure code training?" assumes that training was about writing secure code from scratch. It was not. It was always about building the judgment to recognise insecure code, understand why it is dangerous, and fix it. AI has made that judgment more scarce, more critical, and more directly connected to your risk posture.

The research and evidence show us that AI-generated code is consistently less secure, the humans reviewing it are systematically overconfident, automated tooling misses the majority of real flaws, and iterative AI refinement makes the problem worse, not better.

The security expert in the loop is the control your organisation is currently missing.

*References*

1. Perry, N., Srivastava, M., Kumar, D., & Boneh, D. — *Do Users Write More Insecure Code with AI Assistants?* ACM CCS 2023. `https://dl.acm.org/doi/10.1145/3576915.3623157`
2. Shukla, S., Joshi, H., & Syed, R. — *Security Degradation in Iterative AI Code Generation: A Systematic Analysis of the Paradox.* IEEE-ISTAS 2025, arXiv:2506.11022. `https://arxiv.org/abs/2506.11022`
3. Blain, D. & Noiseux, M. (Cobalt AI) — *Broken by Default: A Formal Verification Study of Security Vulnerabilities in AI-Generated Code.* April 2026, arXiv:2604.05292. `https://arxiv.org/abs/2604.05292`
4. IOActive — *The Security Gap in AI-Generated Code.* April 2026 whitepaper. `https://www.ioactive.com/the-security-gap-in-ai-generated-code/` Full PDF: `https://www.ioactive.com/wp-content/uploads/2026/05/IOA-The-Security-Gap-in-AI-Generated-Code.pdf`
5. Apiiro — *4x Velocity, 10x Vulnerabilities: AI Coding Assistants Are Shipping More Risks.* September 2025. `https://apiiro.com/blog/4x-velocity-10x-vulnerabilities-ai-coding-assistants-are-shipping-more-risks/`
6. CodeRabbit — *State of AI vs Human Code Generation Report.* December 2025. `https://www.coderabbit.ai/blog/state-of-ai-vs-human-code-generation-report`
7. Sonar — *State of Code Developer Survey Report 2026.* January 2026. Landing page: `https://www.sonarsource.com/company/press-releases/sonar-data-reveals-critical-verification-gap-in-ai-coding/` Full PDF: `https://www.sonarsource.com/state-of-code-developer-survey-report.pdf`
8. Google — *DORA State of DevOps Report 2025.* `https://cloud.google.com/blog/products/ai-machine-learning/announcing-the-2025-dora-report`

_This article was originally published on https://secdim.com/blog/post/has-ai-killed-secure-code-training-20355/_
