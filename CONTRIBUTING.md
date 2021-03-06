# Contributing to CCTC

#### Table of Contents
1. Introduction
2. Submitting Issues
3. Professional Git Usage
4. Your First Contribution
5. GitLab Features

## Introduction

This contribution guide will lay out how to do common version control tasks like report issues, update code, and submit
requests to merge your changes back into the master branch.

If you have never used Git or feel a bit rusty, please spend a couple hours reading the
[Atlassian Git Guru Tutorials](https://www.atlassian.com/git/tutorials).

If you have not used Git in a professional environment (i.e. only for personal side projects), the following resources
are worth reading:
- [Git Team Workflow Cheatsheet](https://jameschambers.co/writing/git-team-workflow-cheatsheet/)
- [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)
- [A Rebase Workflow for Git](https://randyfay.com/content/rebase-workflow-git)

This repository will observe the
[Feature Branch Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow).

## Submitting Issues

A core component of the feature branch workflow is to use a different branch for each individual feature or issue. This
implies that every branch should be mapped to an issue.

For example, if you want to create a new CCTC activity that discusses DNS data exfiltration, create a new issue
titled "Create networking activity - Identify DNS data exfiltration". The title should be specific and begin with the
action taken (create, update, delete, etc.).

The body of the issue should reference any code, logs, or thoughts on the issue. It should NOT simply just restate the
title. For example, if there is something broken in the OpenStack environment, the issue should contain the current code
causing the error, log entries relating to the problem, any actions taken to debug the issue, the environment you are
using, and any screenshots if applicable.

Issues are automatically assigned a number when created. **Your branch should begin with this number**, followed by a
dash. This is a feature built-in to GitLab to automatically map issues to branches in the GUI. To build off the DNS
example, the feature branch should be named *13-Create-DNS-data-exfiltration-activity* if the issue created was #13.

## Professional Git Usage

Git can quickly become a real pain if contributors do not use it correctly. Please read the Git Team Workflow Cheatsheet
in the Introduction for a good example of standard workflow.

#### DO NOT:
* Commit directly to the master branch unless it is a very minor change (i.e fix typo, change file name, etc.)
* Have multiple significant changes take place in a single commit
    * Use your best judgment on commit frequency. A good rule of thumb is make a change, test that change, make sure
    nothing broke, & commit.
* Submit a merge request on a feature branch that is not in sync with the master branch
    * Once you believe you are complete with a feature branch, make sure your local feature branch is rebased on top of
    the head of the remote master branch, then submit your merge request. Read the Your First Contribution section for
    more details.

#### DO:
* Write meaningful commit messages. More details on this can be found
[in this blog post](https://chris.beams.io/posts/git-commit/).
* Use the .gitignore file to ignore unnecessary files like compiled executables, temporary files, IDE configurations,
and other files that do not contain code or documentation.
[Here is a good list](https://www.atlassian.com/git/tutorials/saving-changes/gitignore) of files that should be ignored.
* Use social platforms like Slack, GitLab, or face-to-face meetings to discuss changes, de-conflict pull requests, and
other work that is necessary to develop software when working as a team.

## Your First Contribution

Let's walk through a simple example of how you go from an idea to a solution fully merged into the master branch.

The first step is putting the changes into words through the GitLab issue tracker. Read the _Submitting Issues_ section
for more information.

Once you do this, create a new branch in GitLab by going to the repository home page, clicking on the plus sign
drop-down menu, and selecting _New branch_. Make sure the branch name starts with the issue number and then succinctly
paraphrases the issue title.

Next, you will need to run ```git pull``` on your local machine to pull down the new branch. Then you run
```git checkout <feature-branch-name>``` to start working in the new feature branch.

As you start making changes to your specific feature, at some point you will determine you've reached a good point to
stop, test your changes, make sure nothing broke, and commit. To do so, first run ```git status``` to see what files
have changed. If there are files listed that you don't believe should be included in the remote repository (temporary
files, local IDE configurations, compiled binaries, etc.), add them manually to the .gitignore file. From here you can
add the files to git by running ```git add -A```. 
 
After your files have been added, you need to commit your changes to the feature branch.
[Please read this first](https://chris.beams.io/posts/git-commit/) before you make your first commit. A well-written
commit can save a lot of time in the future when something inevitably breaks or needs to change and you want to find
the source of the problem or a good place to start over and try again. And above all, do not be lazy and use the
```-m``` flag unless you are fixing a simple typo or some other very minor change that doesn't warrant a description.

Once you commit your changes, you need to make sure your changes are on top of an up-to-date version of the master
branch. To do this, run the following commands in succession:
* ```git checkout master```
* ```git pull```
* ```git checkout -```
    * the dash is a built-in git variable that represents the previous branch/commit you were working on. In this case,
    it is the name of our feature branch.
* ```git rebase master```
    * Depending on what changes have been made to master since you started working on your feature, there may be merge
    conflicts that you need to resolve. An easy way to avoid this is to separate responsibilities and understand who is
    doing what so only one person at a time is modifying any given file.
* ```git push``` the local feature branch to the remote feature branch.

Now that your remote feature branch is based on top of an up-to-date master branch, you can submit a merge request in
GitLab.

To do this, navigate to your branch in GitLab and click on the _Create merge request_ button. The title should
automatically be generated to say _Resolve "<issue_title>"_ and the description should say _Closes #<issue_number>_. You
should definitely add more to the description to explain how everything turned out, what was tested, and what to expect.

The final step before you submit the merge request is to decide if you want to delete the source branch when the merge
request is accepted. In most cases you should check the box and remove the source branch because the feature is now part
of master and has no reason to continue to exist as a separate branch.

Once you verify everything, submit the merge request. If everything looks good by at least one other person looking over
the changes and verifying that you didn't "break the build", then it will be merged into master.

If something needs to be changed in the feature branch before merging, then make the changes, commit them to the feature
branch, and execute the above commands again to ensure your changes are always on top of an up-to-date master branch.
Rinse and repeat as many times as necessary.

## GitLab Features

GitLab has a treasure trove of features that make collaboration as painless as possible for software developers. At a
minimum, a successful team should be using assignees, labels, and issues when deciding who works on what. 

Assignees simply assigns a GitLab account to an issue. You can assign multiple individuals to an issue.

Labels are useful for creating issue categories. A simple example would be having a Feature label and a Bug label to
differentiate features and bugs. Another example specific to CCTC would be a label to differentiate between the
different modules (Windows, Linux, Networking) and then a generic OpenStack label.

Issues have been explained in-depth already and should be foundational in any team workflow.

##### GitLab IDE

GitLab has a very useful web IDE that allows you to edit files directly within your browser. Changes are tracked
automatically and you can commit to either the current branch or a new branch without touching the command line.

If you are working on a system that you have not configured to your liking or you need to make changes to text documents
that don't require any sort of testing, the web IDE is a very powerful interface. For a more in-depth list of features,
read the documentation [here](https://docs.gitlab.com/ee/user/project/repository/web_editor.html) and
[here](https://docs.gitlab.com/ee/user/project/web_ide/).
