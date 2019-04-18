## From https://gist.github.com/nohwnd/5c07fe62c861ee563f69c9ee1f7c9688 

#Requires -RunAsAdministrator
$modulePath = "C:\Program Files\WindowsPowerShell\Modules\Pester"

if (-not (Test-Path $modulePath)) {
    "There is no Pester folder in $modulePath, doing nothing."
    break
}

takeown /F $modulePath /A /R
icacls $modulePath /reset
icacls $modulePath /grant Administrators:'F' /inheritance:d /T
Remove-Item -Path $modulePath -Recurse -Force -Confirm:$false

## Install Pester from PS Gallery
Install-Module Pester