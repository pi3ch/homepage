---
date: '2025-09-04T00:00:00+10:00'
draft: false
title: 'AI and Secure Code Learning: An Empirical Analysis of 420 AI-Generated Security Fixes'
tags: ["AI", "security", "code", "learning"]
cover:
  image: '/blog/images/ai-negative-impact-secure-code-learning.jpg'
---

A [research study](https://doi.org/10.1016/j.compedu.2013.08.001) comparing click-on (instant lookup) vs key-in (manual typing) digital dictionaries found that **easier look up methods reduced spelling knowledge retention by 20-30%**. Typing words manually requires active cognitive processing while clicking leads to passive consumption.

Learn by writing code, building projects and sandboxing is the most effective way to learn a new coding skill, framework or language. However, since the popularity of generative AI, developers are increasingly relying on AI generated code fixes. This is either because
a) they are under pressure to deliver, or
b) they do not understand a defect (e.g. a security vulnerability) in the first place.

Using AI generated code fixes for security is a double-edged sword: it can be a powerful tool to quickly generate a patch, or it can leave the vulnerability unpatched or introduce a new one.

A [research study](https://arxiv.org/abs/2108.09293) has shown that 40% of the Copilot generated code contains security vulnerabilities. Another study shows that given the right prompt and parameters, [LLMs are reliable in fixing synthetically generated vulnerable code](https://arxiv.org/pdf/2112.02125). However, more recent studies argued that [LLMs struggle to repair over 90% of vulnerabilities in the real-world software without security expert guidance](https://dl.acm.org/doi/10.1145/3716815.3729010).

## Research Question

Aside from reliability of LLMs in fixing security vulnerabilities, there is another interesting issue here:

**Would AI security code fixes help developers in becoming better in secure coding?**

This article aims to answer this question.

## Experiment Setup

We analysed the submissions for some of our AppSec coding challenges. In our platform, we allow developers to download the source code of challenges and use their own IDE with any AI agent tool.

For this experiment, we analysed over 420 submissions. We reviewed a sample of challenges with three degrees of difficulty (easy, medium, and hard) in three languages (Python, Ruby, and Go).

For each submission, we analysed the following metrics:

1. Number of commits
2. Nature of code changes: Insertion, deletion, or replacement.
3. Minimum, maximum and average amount of code diffs between each commit.
4. Minimum, maximum and average time differences between each commit.
5. Minimum, maximum and average file changes between each commit.

This is the screenshot of the challenges that we presented to the developers.

![FirstCon2025 AppSec Wargame by SecDim|535x500](https://discourse-secdim.sgp1.cdn.digitaloceanspaces.com/original/2X/1/1b5860820bfd91071967c7e8267cd287f1a77a23.png)

## Results

The following table summarises the results. A submission is a git commit. Time intervals were calculated from git commit timestamps. For statistical testing, we used Welch’s t-test for unequal variances (if p < 0.05 it shows significant difference). To classify a submission as AI-generated, we looked at Behavioural Indicators and Code Characteristics.

| **Metric** | **AI Fixes** | **Human Fixes** | **Statistical Difference** |
|----|----|----|----|
| Code Diffs (lines) |  |  |  |
| \- Average | 56.3 | 18.4 | p < 0.001\* |
| \- Min | 9 | 1 | \- |
| \- Max | 493 | 166 | \- |
| Time Intervals (minutes) |  |  |  |
| \- Average | 8.2 | 24.7 | p < 0.01\* |
| \- Min | 1 | 1 | \- |
| \- Max | 1380 | 44640 | \- |
| Files Changed |  |  |  |
| \- Average | 1.2 | 1.4 | p = 0.23 |
| \- Min | 1 | 1 | \- |
| \- Max | 2 | 5 | \- |
|  |  |  |  |
| **EASY CHALLENGE** |  |  |  |
| Count | 2 | 35 | \- |
| Code Diffs (avg) | 30.0 | 16.2 | p = 0.15 |
| Time Intervals (avg, min) | 8.0 | 18.3 | p = 0.31 |
| Files Changed (avg) | 1.0 | 1.6 | p = 0.22 |
|  |  |  |  |
| **MEDIUM CHALLENGE** |  |  |  |
| Count | 12 | 9 | \- |
| Code Diffs (avg) | 63.4 | 12.1 | p < 0.001\* |
| Time Intervals (avg, min) | 8.9 | 12.4 | p = 0.52 |
| Files Changed (avg) | 1.2 | 1.0 | p = 0.34 |
|  |  |  |  |
| **HARD CHALLENGE** |  |  |  |
| Count | 8 | 17 | \- |
| Code Diffs (avg) | 48.6 | 26.8 | p < 0.05\* |
| Time Intervals (avg, min) | 7.8 | 36.9 | p = 0.08 |
| Files Changed (avg) | 1.1 | 1.2 | p = 0.71 |
| \*Statistically significant at α = 0.05 |  |  |  |

## Analysis

The data revealed distinct behavioural patterns between AI-generated and human-written code changes. There is a strong correlation between code diffs, time diffs and file changes when comparing AI versus human fixes.

The following graph shows the correlation between AI and human code diffs. As shown, **AI-generated code has large code diffs. It is 3 to 4 times larger than human-written code**.

![Code Diffs AI vs Human|600x371](https://discourse-secdim.sgp1.cdn.digitaloceanspaces.com/original/2X/2/2fb3d01932a678763a355bf628201b68ecf04603.png)

The following graph shows the correlation between AI and human commit time intervals. As it is shown, the commit time intervals were mostly under 5 minutes for AI generated code. **AI generated code fixes are pushed 3 times faster than human-written code**.

![Time Diffs AI vs Human|600x371](https://discourse-secdim.sgp1.cdn.digitaloceanspaces.com/original/2X/d/d383583dc659f4d075c909f880cf683578787a46.png)

Regarding code characteristics, AI-generated code contained mostly examples of textbook-style security patches, with heavy commenting and documentation. It usually had comprehensive error handling unrelated to the security vulnerability.

Human-written code was mostly targeted at minimal required changes and incremental improvements. It primarily added new code with minimal commenting patterns.

Regarding file changes, there were no significant differences between AI and human codes.

Now let’s look at something more interesting.

The following table shows an average comparison of commits for AI-generated and human-written code.

| Metric | AI-Fixes | Human-Fixes | **Ratio** |
|----|----|----|----|
| **Avg Max Commit Size** | 161.8 lines | 17.7 lines | **9.1x larger** |
| **Avg Commits per Repo** | 10.7 commits | 2.2 commits | **4.9x more** |
| **Avg Lines per Commit** | 57.9 lines | 10.9 lines | **5.3x larger** |

Here are some specific example of AI fixes for three developers:

| Challenge | Lines Changed | Time Taken | Speed |
|----|----|----|----|
| **Medium** | 493 lines | 50 seconds | 591 lines/min |
| **Medium** | 308 lines | 34 seconds | 543 lines/min |
| **Medium** | 187 lines | 1 minute | 187 lines/min |

Examining the first developer’s case, they introduced 591 lines of code diffs in one minute. This equates to approximately 10 lines per second. When compared to typical human reading speed of 50-100 lines per minute (with comprehension), this rate is extraordinarily fast and unachievable by humans. Therefore, **this speed makes it physically impossible for developers to comprehend or even carefully validate the changes before pushing.**

## Detailed Analysis

Let’s look at two repositories for an easy challenge where one developer used AI and the other relied on her own brain. The challenge was a vulnerable Django application to integer overflow.

### Example of Human-written Security Patch

The developer had a single commit. The commit changed 2 files and it was mostly adding new lines.

```bash
f758d00 Mon Jun 23 11:52:21 2025 +0000  security fix

src/program/utils.py | 5 ++---
src/program/views.py | 9 ++++++++-
2 files changed, 10 insertions(+), 4 deletions(-)

```

The code change is focused on the root-cause of the vulnerability. The developer modified the two required files with an effective patch (if you want to learn more about this vulnerable, see my article, titled [Write up for Start Here.js: How To and Not To Prevent Integer Overflow in JavaScript](https://discuss.secdim.com/t/write-up-for-start-here-js-how-to-and-not-to-prevent-integer-overflow-in-javascript/353))

```bash
diff --git a/src/program/utils.py b/src/program/utils.py
index a8182f9..b8d26c7 100644
--- a/src/program/utils.py
+++ b/src/program/utils.py
@@ -1,11 +1,10 @@
 import numpy as np
 # 248 * 86400 * 1000
-threshold = np.sum(np.array([2142720000], dtype=np.intc))
+threshold = 2142720000

 def is_optimal(days):
     # days * 86400 * 1000
-    a = np.array([days, 8640000], dtype=np.intc)
-    res = np.multiply(a[0], a[1])
+    res = 8640000 * days
     if(res >= threshold):

diff --git a/src/program/views.py b/src/program/views.py
index 73e21d5..ef3572e 100644
--- a/src/program/views.py
+++ b/src/program/views.py
@@ -9,7 +9,14 @@ def index(request):
     return HttpResponse("[!] Connected to Boeing 787!<br>[?] Enter how many days this Boeing has been operational (1 to 248): http://localhost:8080/isoptimal?days=[1-248]: ")

 def isoptimal(request):
-    days = int(request.GET["days"])
+    try:
+        days = int(request.GET["days"])
+    except (ValueError, TypeError):
+        return HttpResponse("Invalid input: 'days' must be a number.", status=400)
+
+    if days <= 0:
+        return HttpResponse("Negative", status=400)
+
```

### Example of AI Security Patch

The git history of AI fixes for the same easy secure coding challenge is provided below.
As we can see, AI has modified many files. There are lots of code insertion and addition.

```bash
46b6dc1 Tue Jun 24 13:37:39 2025 +0200  test 6
52dbe26 Tue Jun 24 13:32:13 2025 +0200  test 5
bbbd02d Tue Jun 24 13:27:32 2025 +0200  test 4
29ab73a Tue Jun 24 13:22:59 2025 +0200  test 3
382a5bd Tue Jun 24 13:18:05 2025 +0200  test 2
9f777ac Tue Jun 24 13:08:49 2025 +0200  test 1

test 1
src/app/settings.py  |  4 ++--
src/program/views.py | 39 +++++++++++++++++++++++++++++----------
2 files changed, 31 insertions(+), 12 deletions(-)

test 2
src/app/urls.py | 1 +
1 file changed, 1 insertion(+)

test 3
src/program/views.py | 29 ++++++++---------------------
1 file changed, 8 insertions(+), 21 deletions(-)

test 4
src/app/urls.py     | 5 ++---
src/program/urls.py | 2 --
2 files changed, 2 insertions(+), 5 deletions(-)

test 5
src/app/settings.py  |  6 +++---
src/program/utils.py |  6 ++----
src/program/views.py | 17 +++++++++--------
3 files changed, 14 insertions(+), 15 deletions(-)

test 6
src/program/utils.py | 8 ++------
src/program/views.py | 5 ++---
2 files changed, 4 insertions(+), 9 deletions(-)

```

There were completely unnecessary changes to `settings.py` to disable debug mode
and restrict allowed hosts to localhost. AI introduced two new methods. One method added HTTP security headers to the responses. All these changes did not address the vulnerability.

```bash
--- a/src/app/settings.py
+++ b/src/app/settings.py
@@ -23,9 +23,9 @@ BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

 # SECURITY WARNING: don't run with debug turned on in production!
-DEBUG = True
+DEBUG = False

-ALLOWED_HOSTS = ['*']
+ALLOWED_HOSTS = ['127.0.0.1']

diff --git a/src/program/views.py b/src/program/views.py
index 73e21d5..6674514 100644
--- a/src/program/views.py
+++ b/src/program/views.py
@@ -1,17 +1,36 @@

-        return HttpResponse(f"[i] System is optimal<br>Reboot is required in {248 - days} days")
+        out = f"[i] System is optimal<br>Reboot is required in {248 - days} days"
+    resp = HttpResponse(out)
+    _add_security_headers(resp)
+    return resp
+
+def _bad():
+    resp = HttpResponseBadRequest()
+    _add_security_headers(resp)
+    return resp
+
+def _good():
+    resp = HttpResponse("Good")
+    _add_security_headers(resp)
+    return resp
+
+def _add_security_headers(resp):
+    resp['X-Frame-Options'] = 'DENY'
+    resp['X-Content-Type-Options'] = 'nosniff'
+    resp['X-XSS-Protection'] = '1; mode=block'
```

Each time a developer pushes their code, SecDim server tests the code by simulating an attacker and provides the result. This guides the developer in the right track. However, the next two commits does not show if the developer utilised the test out. The commit reverted back some of the changes but did not address the vulnerability.

```bash
diff --git a/src/program/views.py b/src/program/views.py
index 6674514..5cfc1c5 100644
--- a/src/program/views.py
+++ b/src/program/views.py
@@ -2,35 +2,22 @@ from django.http import HttpResponse, HttpResponseBadRequest
 from .utils import is_optimal

 def index(request):
-    resp = HttpResponse("[!] Connected to Boeing 787!<br>[?] Enter how many days this Boeing has been operational (1 to 248): http://localhost:8080/isoptimal?days=[1-248]: ")
-    _add_security_headers(resp)
-    return resp
+    return HttpResponse(
+        "[!] Connected to Boeing 787!<br>[?] Enter how many days this Boeing has been operational (1 to 248): http://localhost:8080/isoptimal?days=[1-248]: "
+    )

 def isoptimal(request):
     days_str = request.GET.get("days", None)
     try:
         if days_str is None or days_str.strip() == "":
-            return _bad()
+            return HttpResponseBadRequest()
         days = int(days_str)
         if days < 1:
-            return _bad()
+            return HttpResponseBadRequest()
     except (ValueError, TypeError):
-        return _bad()
+        return HttpResponseBadRequest()
     res = is_optimal(days)
     if res:
-        out = "[i] Reboot is required"
+        return HttpResponse("[i] Reboot is required")
     else:
-        out = f"[i] System is optimal<br>Reboot is required in {248 - days} days"
-    resp = HttpResponse(out)
-    _add_security_headers(resp)
-    return resp
-def _bad():
-    resp = HttpResponseBadRequest()
-    _add_security_headers(resp)
-    return resp
-
-def _add_security_headers(resp):
-    resp['X-Frame-Options'] = 'DENY'
-    resp['X-Content-Type-Options'] = 'nosniff'
-    resp['X-XSS-Protection'] = '1; mode=block'
+        return HttpResponse(f"[i] System is optimal<br>Reboot is required in {248 - days} days")
```

The next commit is formatting and linting.

```bash
diff --git a/src/app/urls.py b/src/app/urls.py
index 206f611..77aeb50 100644
--- a/src/app/urls.py
+++ b/src/app/urls.py
@@ -14,10 +14,9 @@ Including another URLconf
     2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
 """
 from django.contrib import admin
-from django.urls import include, path
+from django.urls import path, include

 urlpatterns = [
-    path('', include('program.urls')),
     path('admin/', admin.site.urls),
+    path('', include('program.urls')),
 ]
-
diff --git a/src/program/urls.py b/src/program/urls.py
index 7d4e7a4..4a16b52 100644
--- a/src/program/urls.py
+++ b/src/program/urls.py
@@ -2,8 +2,6 @@ from django.urls import path
 from . import views

 urlpatterns = [
-    # /program/
     path('', views.index, name='index'),
-    # /program/1
     path('isoptimal/', views.isoptimal, name='isoptimal'),
 ]
```

These are the final commits. It can show some signs of frustration. **The developer has reverted back all the changes and start from the scratch.** As we can see, the `settings.py` file is again modified. Sadly, the final commit has made changes to `view.py` which has only masked away the vulnerability and has left the vulnerability unpatched in `utils.py`.

```bash
diff --git a/src/app/settings.py b/src/app/settings.py
index 799e1ab..e0b68a0 100644
--- a/src/app/settings.py
+++ b/src/app/settings.py
@@ -20,12 +20,12 @@ BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
 # See https://docs.djangoproject.com/en/3.0/howto/deployment/checklist/

 # SECURITY WARNING: keep the secret key used in production secret!
-SECRET_KEY = '=q$m*%7k-yswz5ienrbkzaej3msmck&6xf6h6xktfnkpk$)s@&'
+SECRET_KEY = os.environ.get("DJANGO_SECRET_KEY", '=q$m*%7k-yswz5ienrbkzaej3msmck&6xf6h6xktfnkpk$)s@&')

 # SECURITY WARNING: don't run with debug turned on in production!
-DEBUG = False
+DEBUG = os.environ.get("DJANGO_DEBUG", "True") == "True"

-ALLOWED_HOSTS = ['127.0.0.1']
+ALLOWED_HOSTS = os.environ.get("DJANGO_ALLOWED_HOSTS", "localhost,127.0.0.1").split(",")


 # Application definition
diff --git a/src/program/utils.py b/src/program/utils.py
index a8182f9..c2f47a7 100644
--- a/src/program/utils.py
+++ b/src/program/utils.py
@@ -1,12 +1,10 @@
 import numpy as np
-# 248 * 86400 * 1000
 threshold = np.sum(np.array([2142720000], dtype=np.intc))

 def is_optimal(days):
-    # days * 86400 * 1000
     a = np.array([days, 8640000], dtype=np.intc)
     res = np.multiply(a[0], a[1])
-    if(res >= threshold):
+    if res >= threshold:
         return True
     else:
-        return False
\ No newline at end of file
+        return False
diff --git a/src/program/views.py b/src/program/views.py
index 5cfc1c5..fb6bb80 100644
--- a/src/program/views.py
+++ b/src/program/views.py
@@ -3,19 +3,20 @@ from .utils import is_optimal

 def index(request):
     return HttpResponse(
-        "[!] Connected to Boeing 787!<br>[?] Enter how many days this Boeing has been operational (1 to 248): http://localhost:8080/isoptimal?days=[1-248]: "
+        "[!] Connected to Boeing 787!<br>[?] Enter how many days this Boeing has been operational (1 to 248): "
+        "http://localhost:8080/isoptimal?days=[1-248]: "
     )

 def isoptimal(request):
-    days_str = request.GET.get("days", None)
+    days_str = request.GET.get("days", "")
     try:
-        if days_str is None or days_str.strip() == "":
-            return HttpResponseBadRequest()
         days = int(days_str)
-        if days < 1:
-            return HttpResponseBadRequest()
-    except (ValueError, TypeError):
-        return HttpResponseBadRequest()
+        if not (1 <= days <= 248):
+            if days < 1:
+                return HttpResponseBadRequest("Invalid number of days. Must be between 1 and 248.")
+    except ValueError:
+        return HttpResponseBadRequest("Invalid number of days. Must be integer.")
+

diff --git a/src/program/utils.py b/src/program/utils.py
index c2f47a7..8b9453a 100644
--- a/src/program/utils.py
+++ b/src/program/utils.py
@@ -2,9 +2,5 @@ import numpy as np
 threshold = np.sum(np.array([2142720000], dtype=np.intc))

 def is_optimal(days):
-    a = np.array([days, 8640000], dtype=np.intc)
-    res = np.multiply(a[0], a[1])
-    if res >= threshold:
-        return True
-    else:
-        return False
+    # Returns True if reboot is required, else False
+    return days >= 248
diff --git a/src/program/views.py b/src/program/views.py
index fb6bb80..0906086 100644
--- a/src/program/views.py
+++ b/src/program/views.py
@@ -11,9 +11,8 @@ def isoptimal(request):
     days_str = request.GET.get("days", "")
     try:
         days = int(days_str)
-        if not (1 <= days <= 248):
-            if days < 1:
-                return HttpResponseBadRequest("Invalid number of days. Must be between 1 and 248.")
+        if not (1 <= days):  # allow any number >= 1 for reboot, but <1 is error
+            return HttpResponseBadRequest("Invalid number of days. Must be at least 1.")
     except ValueError:
         return HttpResponseBadRequest("Invalid number of days. Must be integer.")
```

## AI’s Adverse Impact on Secure Code Skill Development

Our analysis showed that when AI-generated code was readily available, developers simply accepted it. They did not invest time in reviewing the generated code, reasoning about it, removing unnecessary changes, or tweaking it to properly patch vulnerabilities. The ease of accepting AI output has resulted in passive consumption. Developers in our experiments showed a similar behavioural pattern to the [digital dictionary research study](https://doi.org/10.1016/j.compedu.2013.08.001) (comparing click-on versus manual typing of words).

**Over-reliance on AI leads to significant reduction in critical thinking, problem-solving ability and skill development over time.** Similar [research studies](https://arxiv.org/pdf/2212.01020) on AI’s role in education have highlighted the risks of learners’ over-reliance on generated outputs. They found that learners quickly become accustomed to auto-suggested solutions and don’t think about the steps required to solve coding problems.

Developers’ over-reliance on AI results in [overlooking potential security vulnerabilities](https://pmc.ncbi.nlm.nih.gov/articles/PMC11128619/) and a decline in their secure coding awareness. This has also given rise to optimism bias, where [some believe AI coding tools enhance security](https://www.codefortify.ai/resources/vibe-coding-and-cves) and therefore blindly accept AI-generated diffs. As we can see in the first two commits of the AI-generated code example, this bias partly stems from well-formatted, professional-looking AI-generated code. It instils a false sense of security and masks underlying security flaws.

The secure coding challenges reviewed in this experiment were simple web applications with few lines of code and files. These do not resemble the reality of production applications, which are complex and intertwined. Production environments require deeper contextual understanding to detect or fix potential security vulnerabilities. However, [over-reliance on AI deepens the comprehension gap](https://arxiv.org/html/2412.15004v3) where developers may no longer understand how to address these issues.

## Conclusion

The objective of this experiment was to evaluate the impact of AI on secure code learning. The data showed that developers often *“just accept all”* AI-generated code without truly understanding it. Unrealistically short time intervals between large and complex commits provided clear evidence that code review, comprehension, and testing were not taking place.

Although this was a short experiment, the findings aligned with other research studies. We can confidently conclude that if AI is not used correctly, it can lead to over-reliance and the degradation of secure coding skills.

### For learners

Be aware of AI’s potential negative impact on your critical thinking and skill development:

1. Allocate time to understand the generated code.
2. Remember even if the code looks professional and well-formatted, it may still be incorrect.
3. Scrutinise the output to ensure it addresses the root cause of the issue.
4. Review your prompt carefully and make sure you’ve included all necessary instructions. AI is non-deterministic — a single keyword change can produce very different results.
5. Use a different LLM model to cross-review the generated output. Most IDEs now make switching between models easy.
6. Never accept code changes you do not fully understand.

### For code reviewers and technical leads

1. Implement automated checks in CI pipelines to flag AI-generated code.
2. Monitor commit diffs and time intervals, rejecting suspicious activity. For example, 500 code changes in 50 seconds strongly indicates unaudited, generated code. (See the Analysis section for supporting stats.)
3. Use an alternate LLM model to review submitted changes.
4. Regularly remind your team of the risks and potential downsides of AI reliance.

### Our approach at SecDim

When designing the **SecDim AI coding mentor, Dr. SecDim**, we intentionally restricted certain capabilities. The AI does not provide complete coding answers, nor does it allow direct acceptance of suggestions. Instead, users must type in AI recommendations manually. This design has helped our users to utilise the best of AI coding mentors, avoiding over-reliance whilst supporting them through a tailored learning path.

Let me conclude this post with a relevant word of wisdom from the greatest figure in classical Persian literature, Saadi Shirazi (13th century poet):

نابرده رنج گنج میسر نمی شود - مزد آن گرفت جان برادر که کار کرد
Without pain,  you don’t find a treasure (no pain, no gain) - The reward was taken by the brother who worked hard.
