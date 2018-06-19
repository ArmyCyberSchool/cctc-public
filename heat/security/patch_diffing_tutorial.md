## Intro
This file will explain the general process for extracting the relevant files
from Windows patches to use in patch diffing tools like IDA Pro or radiff2

## Step 1: Identify Patch/Exploit
In order to begin either analyzing a new Microsoft patch for 1-day exploit
development or understand an existing MS exploit, you need to identify which
security bulletins are relevant.

For this tutorial, I'm going to use MS16-009,
[which can be found here](https://docs.microsoft.com/en-us/security-updates/securitybulletins/2016/ms16-009)
. Security bulletins are numbered by the year and the release number. So in this
case, I'm looking at the 9th security bulletin from 2016. In this release,
Microsoft released a patch for Internet Explorer 9,10, and 11. It is a critical
vulnerability for Windows clients, and a moderate vulnerability for servers.

The two relevant columns in the **Affected Software** list are the *Operating
System* and the *Updates Replaced*. If you are developing an exploit for a
specific version of Windows (or in this case, Internet Explorer), then you will
obviously need to select the correct patch.

The *Updates Replaced* column is the previous patch that is being replaced. In
this case, Security Bulletin MS16-001 has the older version of whatever files
are being patched in this update.

Note that, starting with Windows 10, the Windows Update Service uses "cumulative
updates", which makes patch diffing much more difficult. For learning purposes,
just stick with Windows XP to Windows 8.

## Step 2: Download new patch and old patch

If you click on any of the affected software links, you will download an exe/msi
file that contains the patch. Once this is complete, go back to the previous
page, click on the *Updates Replaced* link, and download the old patch. If it
says *N/A*, that means you can just diff the exe/dll file that already exists
on your operating system. 

## Step 3: Extract binaries from the patches

Navigate to wherever you downloaded the patch. Move each patch to their own
folder. Open a command prompt in that folder, and execute the following command:
`expand -F:* <name_of_patch> <output_dst>`

This will produce a few files. Run the command above again on the *.cab* file.
The *.cab* file will produce a lot of output.

From here, you will need to do a bit more research to see which files are being
patched. There will be a bunch of folders created, and in each of those folders
will be the patched binaries. Depending on which patch you are looking at, you
might only care about a single DLL or a single EXE file. 

For this tutorial, the only file we care about is urlmon.dll. Look in the x86
folders for it and place them somewhere else to seperate the file we care about
from the rest of the output (make sure to not mix them up!)

Once you have the two seperate urlmon.dll files, you can begin to compare them
and find out exactly what the differences are.

For more information about patch diffing, check out these links:
- https://www.rsaconference.com/writable/presentations/file_upload/ht-t10-bruh_-do-you-even-diff-diffing-microsoft-patches-to-find-vulnerabilities.pdf
- http://www.alex-ionescu.com/?p=271
- https://www.blackhat.com/presentations/bh-usa-09/OH/BHUSA09-Oh-DiffingBinaries-SLIDES.pdf



