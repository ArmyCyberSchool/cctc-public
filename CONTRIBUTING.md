# Contributing to CCTC

#### Table of Contents
1. Introduction
2. Submitting Issues
3. Professional Git Usage
4. Your First Contribution
5. Labels, Commits, and More

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
[Feature Branch Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow). If you
are not familiar with this workflow, please read the linked tutorial.

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
* Submit a pull request on a feature branch that is not in sync with the master branch
    * Once you believe you are complete with a feature branch, make sure your local feature branch is rebased on top of
    the head of the remote master branch, then submit your pull request.
    [Something like this](https://coderwall.com/p/9idt5g/keep-your-feature-branch-up-to-date) might be useful to add to
    your environment and run every time you are about to commit.
* Use git rebase if you are not finished with your feature. If you want to incrementally

#### DO:
* Write meaningful commit messages. More details on this can be found below.
* Use the .gitignore file to ignore unnecessary files like compiled executables, temporary files, IDE configurations,
and other files that do not contain code or documentation.
[Here is a good list](https://www.atlassian.com/git/tutorials/saving-changes/gitignore) of files that should be ignored.
* Use social platforms like Slack, GitLab, or Github to discuss changes, de-conflict pull requests, and other work that
is necessary to develop software when working as a team. Don't expect people to understand the changes you've made
unless you communicate with them directly.

## Your First Contribution

Let's walk through a simple example of how you go from an idea to a solution fully merged into the master branch.

The first step is putting the changes into words through the GitLab issue tracker.
[Here is a simple example template](https://github.com/Urigo/angular-meteor/blob/master/.github/ISSUE_TEMPLATE.md) for
how to create issues related to bugs or feature requests.

Once you do this, create a new branch in GitLab by going to the repository home page, clicking on the plus sign
drop-down menu, and selecting _New branch_. Make sure the branch name starts with the issue number and then succinctly
paraphrases the issue title.

Next, you will need to run ```git pull``` on your local machine to pull down the new branch. Then you run
```git checkout <feature-branch-name>``` to start working in the new feature branch.

As you modify code or documentation, at some point you will determine you've reached a good point to stop, test your
changes, make sure nothing broke, and commit. To do so, first run ```git status``` to see what files have changed.
If there are files listed that you don't believe should be included in the remote repository (temporary files, local
IDE configurations, compiled binaries, etc.), add them manually to the .gitignore file. From here you can add the files
to git by running ```git add -A```. 
 
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
* ```git fetch origin```
* ```git rebase master```
    * Depending on what changes have been made to master since you started working on your feature, there may be merge
    conflicts that you need to resolve. Do this before you run the rest of the commands. An easy way to avoid this is to
    separate responsibilities and communicate who is doing what so only one person is modifying a file at any time.
    * 
* ```git push``` the local feature branch to the remote feature branch.

Now that your remote feature branch is based on top of an up-to-date master branch, you can submit a merge request in
GitLab.

To do this, navigate to your branch in GitLab and click on the _Create merge request_ button. The title should
automatically be generated to say _Resolve "<issue_title>"_ and the description should say _Closes #<issue_number>_.

The final step before you submit the merge request is to decide if you want to delete the source branch when the merge
request is accepted. In most cases you should remove the source branch because the feature is now part of master and has
no reason to still exist as a seperate branch.

Once you verify everything, submit the merge request. If everything looks good by at least one other person looking over
the changes and verify that the changes don't "break the build", then it will be merged into master.

If something needs to be changed in the feature branch before merging, then make the changes, commit them to the feature
branch, and execute the above commands again to ensure your changes are always on top of an up-to-date master branch.
Rinse and repeat as many times as necessary.

## Labels, Commits, and More

