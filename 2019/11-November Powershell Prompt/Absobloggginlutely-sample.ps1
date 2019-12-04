#github.com/absoblogginlutely

if (test-path ("c:\temp\pslogs\powershelllogs-" + $env:username + (get-date -uformat "%y%m%d") + "*.txt")) {$alreadyrun = $true}
$transcriptlog = "c:\temp\pslogs\powershelllogs-" + $env:username + (get-date -uformat "%y%m%d-%H%M%S") + ".txt"

start-transcript $transcriptlog
$host.ui.rawui.WindowTitle = $transcriptlog

Set-PSReadLineOption -AddToHistoryHandler {
    param([string]$line)

    $sensitive = "password|asplaintext|token|key|secret|credential"
    return ($line -notmatch $sensitive)
}


Function Prompt {
# Admin ?
    if( (
        New-Object Security.Principal.WindowsPrincipal (
            [Security.Principal.WindowsIdentity]::GetCurrent())
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        # Admin-mark in WindowTitle
        if ($Host.UI.RawUI.WindowTitle -notlike "*[Admin]*") {$Host.UI.RawUI.WindowTitle = "[Admin] " + $Host.UI.RawUI.WindowTitle}
 
        # Admin-mark on prompt
        Write-Host "[" -nonewline -foregroundcolor DarkGray
        Write-Host "A" -nonewline -foregroundcolor Red
        Write-Host "] " -nonewline -foregroundcolor DarkGray
    }
 
   Write-Host $((Date -uformat %T).ToString()) -NoNewline
    Write-Host  ":" $(Get-CustomDirectory) -ForegroundColor Green  -NoNewline
    Write-Host ">" -NoNewline -ForegroundColor Yellow
 
   <# # Split path and write \ in a gray
    $pwd.Path.Split("\") | foreach {
        Write-Host $_ -nonewline -foregroundcolor Yellow
        Write-Host "\" -nonewline -foregroundcolor Gray
    }
 
    # Backspace last \ and write >
    Write-Host "`b>" -nonewline -foregroundcolor Gray
 #>
    return " "
}


if (!$alreadyrun) {
    #Anything in this script block will only run once per day
    get-packt
    choco outdated
    write-host "To update... cup all -y "
"Checking for Module updates"
	$a=update-module
}

$PSVersionTable.PSVersion

#https://geekeefy.wordpress.com/2017/02/02/highlighting-words-in-a-text-content-or-files-in-powershell-console/
#https://geekeefy.wordpress.com/2016/10/19/powershell-customize-directory-path-in-ps-prompt/
#https://gallery.technet.microsoft.com/Office-365-Connection-47e03052 
