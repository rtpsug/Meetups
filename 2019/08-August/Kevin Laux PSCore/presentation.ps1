#Old Install Method
    #Silent Install PowerShell Core
    Start-Process msiexec.exe -Wait -ArgumentList '/I C:\temp\PowerShell-6.2.0-rc.1-win-x64.msi /q'
  
    #Add Env Path for PSCore   
    $env:Path="$env:Path;C:\Program Files\PowerShell\6\;C:\Program Files\PowerShell\7-preview\"
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $env:Path

    #Install OpenSSH
    & 'C:\Program Files\OpenSSH-Win64\install-sshd.ps1'

    #Add Env Path for OpenSSH
    $env:Path="$env:Path;C:\Program Files\OpenSSH-Win64"
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $env:Path

    #Open Firewall for OpenSSH
    New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    #Set OpenSSH to Auto Start

    Set-Service -Name sshd -StartupType Automatic
    #Starts OpenSSH to generate default config
    Start-Service -Name sshd
    #Stops OpenSSH so we can edit config
    Stop-Service -Name sshd

#Windows ModulePSReleaseTools module (https://github.com/jdhitsolutions/PSReleaseTools)
#Oneliners:
    #Windows- iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
    #Linux- wget https://aka.ms/install-powershell.sh; sudo bash install-powershell.sh -preview; rm install-powershell.sh
#On Linux install package yum/apt-get
#On MAC Brew
#Manual Download MSI/RPM/PKG

Get-PSSessionConfiguration | Select Name

#Install Powershell on Windows
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"

#Path variables appear after restart PS7 has a path to a preview folder that redirects to pwsh.exe
Restart-Computer

#Enable PSremoting in both PSCore and PS7
pwsh
Enable-PSRemoting
Exit
pwsh-preview.cmd
Enable-PSRemoting
Exit

Invoke-Command -ComputerName pswindows -ScriptBlock {Get-PSSessionConfiguration | Select Name}
Enter-PSSession pswindows -ConfigurationName PowerShell.6.2.2
$PSversiontable
#compare to PowerShell 5 in console
Exit-PSSession
Enter-PSSession pswindows -ConfigurationName PowerShell.7-preview
$PSversiontable
Exit-PSSession


$configs = Invoke-Command -ComputerName pswindows -ScriptBlock {Get-PSSessionConfiguration | Select Name} | where Name -like 'PowerShell*'
$sessions = @()
$sessions += New-PSSession pswindows

foreach($config in $configs){
    $sessions += New-PSSession -ComputerName pswindows -ConfigurationName $config.Name
}
$sessions
Invoke-Command -Session $sessions -ScriptBlock{$PSversiontable}

$sessions | Remove-PSSession
$sessions = @()
#Install SSH on Windows on VMware console
#Check OpenSSH

Get-WindowsCapability -Online | Where Name -like 'OpenSSH*'  

# Install the OpenSSH Client and Server needs local admin access

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
 
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
 
# Initial Configuration of SSH Server

Enter-PSSession pswindows

Start-Service sshd
 
Set-Service -Name sshd -StartupType 'Automatic'
 
# Confirm the Firewall rule is configured. It should be created automatically by setup.
 
Get-NetFirewallRule -Name *ssh*
 
# There should be a firewall rule named "OpenSSH-Server-In-TCP", which should be enabled

& cmd /c mklink /d 'c:\pwsh' 'C:\Program Files\PowerShell\6'

#Removes commenting from user auth line in config
(Get-Content -Path $env:ProgramData\ssh\sshd_config -Raw) -replace '#PasswordAuthentication yes', 'PasswordAuthentication yes'| Set-Content $env:ProgramData\ssh\sshd_config
#Add PSCore to Subsystem in config
(Get-Content $env:ProgramData\ssh\sshd_config) -replace "# override default of no subsystems", "$&`nSubsystem`tpowershell`tC:/pwsh/pwsh.exe -sshs -NoLogo -NoProfile" | Set-Content $env:ProgramData\ssh\sshd_config

Restart-Service sshd

#Install SSH on Linux if not already
#Update /etc/ssh/sshd_config
#Add line "Subsystem       powershell   /usr/bin/pwsh --sshs -NoLogo -NoProfile"
#Remove commenting on "#PasswordAuthentication yes"
#clean up trusted keys if snapshot reverted
##BEWARE OF TYPING LAG##
Enter-PSSession -hostname pswindows

Get-Content $env:ProgramData\ssh\sshd_config

$Linux = '192.168.20.32'
$Mac = '192.168.20.33'
$Windows = '192.168.20.31'

#test
#Connect to Linux (Delay in openssh response)
Enter-PSSession -hostname $Linux
#
$PSversiontable
#
if($PSversiontable.OS | Select-String Linux){Write-Host "I am Linux" -ForegroundColor Green}
#
if($PSversiontable.OS | Select-String Windows){Write-Host "I am Windows"}
#BEWARE Do not get caught using the wrong CASE 'Grep' <> 'grep'
if($PSversiontable.OS | grep Linux){Write-Host "I am Linux"}
Get-alias grep
# Easier Method
$IsLinux
#
$IsWindows
#
$IsMacOS
#
if($IsLinux){Write-Host "I am Linux" -ForegroundColor Green}
#How many Cmdlets do we have?
$(Get-Command -CommandType Cmdlet | Measure-Object).count
#Close Session
Exit-PSSession

#Connect with OpenSSH
Enter-PSSession -hostname $Windows
$PSversiontable
if($isWindows){Write-Host "I am Windows" -ForegroundColor Blue}
#Close Session
Exit-PSSession

#MultiSession
$sessions = @()
$sessions += New-PSSession pswindows
$sessions += New-PSSession -hostname $Linux
$sessions += New-PSSession -hostname $Windows
$sessions += New-PSSession -hostname $Mac -Username klaux
$sessions += New-PSSession pswindows -ConfigurationName PowerShell.7-preview


#Lets see what our sessions look like
$sessions

#Now that I have created the sessions lets send them all a command
Invoke-Command -Session $sessions -scriptblock {$PSVersionTable}
Invoke-Command -Session $sessions -scriptblock {$PSVersionTable.PSVersion}
Invoke-Command -Session $sessions -scriptblock {$PSVersionTable.PSVersion | Format-List}

#What else could I do? lets try looping through the sessions and returning some information
$Info = @()
$Info = Foreach($session in $sessions){
    Invoke-Command $session -ScriptBlock{
        $OS = 'Did not process'
        switch ( $true )
        {
            $IsLinux{ $OS = 'Linux'}
            $IsWindows{ $OS = 'Windows'}
            $IsMacOS{ $OS = 'Mac'}
            default{ $OS = 'Windows PS'}
        }
        $myObject = [PSCustomObject]@{
            OS          = $OS
            Commands    = Get-Command -CommandType Cmdlet
            Count       = (Get-Command -CommandType Cmdlet | Measure-Object).count
            Version     = $PSversiontable.PSVersion.Major
        }
        Return $myObject
    }
}
#Whats in $info?
$Info

#Lets Split that into Local Variables
$PS5Commands = $($Info | Where-Object OS -eq 'Windows PS').Commands.Name
$PS6Commands = $($Info | Where-Object {($_.OS -eq 'Windows') -and ($_.Version -eq '6')}).Commands.Name
$PS7Commands = $($Info | Where-Object {($_.OS -eq 'Windows') -and ($_.Version -eq '7')}).Commands.Name
$PSLinuxCommands = $($Info | Where-Object OS -eq 'Linux').Commands.Name
$PSMacCommands = $($Info | Where-Object OS -eq 'Mac').Commands.Name

#Whats the difference?
Write-Host "Windows PS 5 has: $($PS5Commands.count) Commands" -ForegroundColor Green
Write-Host "Windows PS Core on Windows has: $($PS6Commands.count) Commands" -ForegroundColor Yellow
Write-Host "Windows PS 7 on Windows has: $($PS7Commands.count) Commands" -ForegroundColor Blue
Write-Host "Windows PSCore on Linux has: $($PSLinuxCommands.count) Commands" -ForegroundColor Red
Write-Host "Windows PSCore on Mac has: $($PSMacCommands.count) Commands" -ForegroundColor Cyan

#Which Commands are where?
Compare-Object $PS5Commands $PS6Commands
#
Compare-Object $PS6Commands $PSLinuxCommands
#
Compare-Object $PS5Commands $PSLinuxCommands
#
Compare-Object $PS7Commands $PS6Commands
#
Compare-Object $PSMacCommands $PSLinuxCommands


#How can we make this a bit more understandable?
$allcommands = $PS5Commands
$allcommands += $PS6Commands
$allcommands += $PS7Commands
$allcommands += $PSLinuxCommands
$allcommands += $PSMacCommands
$allcommands = $allcommands | Select-Object -Unique
$allcommands.count

$Table = @()
foreach($command in $allcommands){

    $myObject = [PSCustomObject]@{
        Cmdlet                  = $command
        'PowerShell 5'          = $PS5Commands.Contains($command)
        'PowerShell Core'       = $PS6Commands.Contains($command)
        'PowerShell 7'          = $PS7Commands.Contains($command)
        'PowerShell Core Linux' = $PSLinuxCommands.Contains($command)
        'PowerShell Core Mac'   = $PSMacCommands.Contains($command)
    }
    $table += $myObject
}
#What does it look like
$Table
#Lets save it to a CSV
$Table | Export-Csv 'c:\temp\output.CSV'

Get-PSSession | Remove-PSSession