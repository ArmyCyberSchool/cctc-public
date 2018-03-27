#ps1_sysnative
            $ErrorActionPreference = 'SilentlyContinue'
            netsh advfirewall set allprofiles state off
            # set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -name "dontdisplaylastusername" -Value 1
            
            # ----- DISABLE PASSWORD COMPLEXITY REQUIREMENT
            secedit /export /cfg c:\secpol.cfg
            (gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
            (gc C:\secpol.cfg).replace("MinimumPasswordLength = 7", "MinimumPasswordLength = 1") | Out-File C:\secpol.cfg
            (gc C:\secpol.cfg).replace("SeInteractiveLogonRight = *S-1-5-32-544,*S-1-5-32-548,*S-1-5-32-549,*S-1-5-32-550,*S-1-5-32-551,*S-1-5-9", "SeInteractiveLogonRight = *S-1-5-32-544,*S-1-5-32-548,*S-1-5-32-549,*S-1-5-32-550,*S-1-5-32-551,*S-1-5-9,*S-1-1-0,*S-1-5-11") | Out-File C:\secpol.cfg
            secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg
            rm -force c:\secpol.cfg -confirm:$false
            
            # ----- INSTRUCTOR NEEDS TO LOGIN AS ONE OR MORE USERS TO DEMO MIMIKATZ
            net user /add Bill DoDC0mPL1antPassW0rd!! /y
            net localgroup administrators /add Bill
            net user /add Susan Susan+Cats /y
            net user /add Robert PassWord123 /y
            net user /add Jacob UberL0ngPassw0rd /y
            net user /add Eeyore hatemyjob /y
            net user /add Ian password /y
            net localgroup administrators /add Eeyore
            net user /add $user $password /y
            
            Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
            
            # ----- UNINSTALLS KBs FOR EXPLOITATION
            Invoke-WebRequest -Uri "10.50.21.12/linux/KB.ps1" -OutFile "C:\KB.ps1"
            (new-object Net.WebClient).DownloadFile( "http://10.50.21.12/linux/KB.ps1", "C:\KB.ps1" )
            Invoke-WebRequest -Uri "10.50.21.12/windows/.hidden/TTW/PsExec.exe" -OutFile "C:\PsExec.exe"
            (new-object Net.WebClient).DownloadFile( "http://10.50.21.12/windows/.hidden/TTW/PsExec.exe", "C:\PsExec.exe" )
            Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -name "KB" 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -noprofile -sta -File "C:\KB.ps1"'
            New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name AUOptions -Value 1 -PropertyType Dword | Out-Null
            get-service wuauserv | stop-service -Force
            C:\PsExec.exe -accepteula -u Bill -p DoDC0mPL1antPassW0rd!! \\$(hostname) cmd /c "exit" -accepteula -nobanner
            C:\PsExec.exe -accepteula -u Eeyore -p hatemyjob \\$(hostname) cmd /c "exit" -accepteula -nobanner

            # -----Windows Configs
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
            shutdown -r -f