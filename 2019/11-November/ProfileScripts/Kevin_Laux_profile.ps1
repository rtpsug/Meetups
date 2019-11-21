#$PROFILE.CurrentUserCurrentHost
<#
    Description	Name
    Current User, Current Host	$PROFILE
    Current User, Current Host	$PROFILE.CurrentUserCurrentHost
    Current User, All Hosts	$PROFILE.CurrentUserAllHosts
    All Users, Current Host	$PROFILE.AllUsersCurrentHost
    All Users, All Hosts	$PROFILE.AllUsersAllHosts
#>
#powershell_ise $PROFILE
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )
if ($currentPrincipal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator ))
{
    #(get-host).UI.RawUI.Backgroundcolor="DarkRed"
    Write-Host "Warning: PowerShell is running as an Administrator." -BackgroundColor "Green"
}
else{
    #Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White
    <#
    ForegroundColor       : DarkYellow
    BackgroundColor       : DarkMagenta
    CursorPosition        : 0,47
    WindowPosition        : 0,0
    CursorSize            : 25
    BufferSize            : 120,3000
    WindowSize            : 120,50
    MaxWindowSize         : 120,72
    MaxPhysicalWindowSize : 274,72
    KeyAvailable          : False
    WindowTitle           : Windows PowerShell
    #>
    #(get-host).UI.RawUI.Backgroundcolor="Blue"
    Write-Warning "Warning: PowerShell is running without Admin rights to change this Run Set-Administrator"
    function Set-Administrator{
        if($psISE){
            Write-Host "You will lose any unsaved data, make sure to save. Type any key to Stop or press Enter to continue to an Administrator ISE"
            if(!(Read-Host)){
                Start-Process PowerShell_ISE.exe -Verb Runas
                Get-Process -PID $PID | Stop-Process
            }
            return
        }
        if($host.Name -eq "ConsoleHost"){
            Write-Host "You will lose any unsaved data, make sure to save. Type any key to Stop or press Enter to continue to an Administrator ISE"
            if(!(Read-Host)){
                Start-Process PowerShell.exe -Verb Runas
                Get-Process -PID $PID | Stop-Process
            }
            return
        }

    }
}