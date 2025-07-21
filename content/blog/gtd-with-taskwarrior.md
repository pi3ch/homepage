---
date: '2012-01-09T17:22:02+10:00'
draft: false
title: 'Gtd With Taskwarrior'
tags: ["linux","taskwarrior"]
---

[Taskwarrior](https://taskwarrior.org/) is a minimalist command line tool to
organise tasks and to-do lists. It is highly configurable. It can also be
executed under Cygwin (Windows).

You can configure the view of the tasks (lists)
in any order that you interested. Below is my configuration settings to generate
reports based on Getting Things Done (GTD):

Save below lines in .taskrc file(e.g. /home/USERNAME/.taskrc)
```
report.gtd.columns=tags,id,description,project,due
report.gtd.description=List GTD style task
report.gtd.filter=status:pending limit:page
report.gtd.labels=Context,ID,Task,Project,Due
report.gtd.sort=tags+,due+,project+,description+
```

Then run:
```
task gtd
```

* Tip 1: You can set `default.command=gtd`
* Tip 2: Create an alias in .bashrc file i.e. `alias t='task'`
