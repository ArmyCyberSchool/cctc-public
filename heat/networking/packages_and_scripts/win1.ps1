#ps1_sysnative
            $ErrorActionPreference = 'SilentlyContinue'
            netsh advfirewall set allprofiles state off
            set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0
            set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -name "dontdisplaylastusername" -Value 1
            (new-object System.Net.WebClient).DownloadFile('https://download.mozilla.org/?product=firefox-48.0.2-SSL&os=win64&lang=en-US','C:\firefox.exe')
            & c:\firefox.exe -ms
            (new-object System.Net.WebClient).DownloadFile('https://notepad-plus-plus.org/repository/6.x/6.9.2/npp.6.9.2.Installer.exe','C:\npp.exe')
            & c:\npp.exe /S
            (new-object System.Net.WebClient).DownloadFile('https://the.earth.li/~sgtatham/putty/latest/x86/putty-0.67-installer.msi','C:\putty.msi')
            & msiexec /i c:\putty.msi /quiet /passive
            net user /add $user $password /y
            net localgroup administrators /add $user
            exit 1001