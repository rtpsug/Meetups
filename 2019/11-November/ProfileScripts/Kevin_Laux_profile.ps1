$currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )
if ($currentPrincipal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator ))
{
    #(get-host).UI.RawUI.Backgroundcolor="DarkRed"
    Write-Host "Warning: PowerShell is running as an Administrator." -BackgroundColor "Green"
}
else{
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
