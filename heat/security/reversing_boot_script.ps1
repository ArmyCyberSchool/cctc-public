#ps1_sysnative

$ErrorActionPreference = 'SilentlyContinue'
netsh advfirewall set allprofiles state off
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

net user /add $user $password /y
net localgroup administrators /add $user

# Install basics like browser, editor, and SSH client
(new-object System.Net.WebClient).DownloadFile('https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US','C:\firefox.exe') & c:\firefox.exe -ms
(new-object System.Net.WebClient).DownloadFile('https://notepad-plus-plus.org/repository/6.x/6.9.2/npp.6.9.2.Installer.exe','C:\npp.exe') & c:\npp.exe /S
(new-object System.Net.WebClient).DownloadFile('https://the.earth.li/~sgtatham/putty/latest/x86/putty-0.67-installer.msi','C:\putty.msi') & msiexec /i c:\putty.msi /quiet /passive

# Download r2 and installer README
(new-object System.Net.WebClient).DownloadFile('http://radare.mikelloc.com/get/2.6.0/radare2_installer-msvc_32-2.6.0.exe','C:\radare2_installer.exe')
(new-object System.Net.WebClient).DownloadFile('https://git.cybbh.space/CCTC/public/raw/master/heat/security/radare2_installer_readme.md','C:\Users\$(user)\Desktop\README.md')
