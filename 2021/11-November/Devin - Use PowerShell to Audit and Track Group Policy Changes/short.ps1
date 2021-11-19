# Sample TrackGpo setup
# Interactive 1st time portion:
Install-Module TrackGpo -Scope CurrentUser
Install-Module TrackGpo_Smtp -Scope CurrentUser
Invoke-GpoTracking -GpoRepo GpoStore -WorkingDir GpoStore_working -Initialize

# Recurring operations:
# Get secure string or credential object
$emailCred = [pscredential]::new("username", $SecureString)
New-TrackGpoSmtpConfig -SmtpServer "<smtpserver>" -Port 587 -From $EmailCred.UserName -To $EmailCred.UserName -UseSsl -Credential $EmailCred
Invoke-GpoTracking -GpoRepo GpoStore -WorkingDir GpoStore_working
# Please use a splat if you are making a script with the above code.
# Honestly, look how much better this is:
$emailCred = [pscredential]::new("username", $SecureString)
$smtpConfig_splat = @{
    SmtpServer = "<smtpserver>"
    Port       = 587
    From       = $EmailCred.UserName
    To         = $EmailCred.UserName
    UseSsl     = $true
    Credential = $EmailCred
}
New-TrackGpoSmtpConfig @smtpConfig_splat
Invoke-GpoTracking -GpoRepo GpoStore -WorkingDir GpoStore_working
# Use splatting for anytime than you program more than about 3-4 parameters in your code!

# Alternate scenarios/advanced usage:
# With less fluff around GPO changes:
Invoke-GpoTracking -GpoRepo GpoStore -WorkingDir GpoStore_working -SkipCommonChanges -GpoChangeContext 0
# Bring your own Git repo (BYOG):
Invoke-GpoTracking -GpoRepo GpoStore -WorkingDir GpoStore_working
git -C GpoStore push
# Direct mirror of GPOs to disk with no Git stuff:
Invoke-GpoTracking -GpoRepo GpoStore -WorkingDir GpoStore_working -RemoveDeletedPolicies -RemoveOldPolicyVersions -DisableGitRepo

# Extending capabilities (external functions)
function New-TrackGpoTicket_External {
    param(
        [ValidateSet("Add", "Remove", "Change")]
        [parameter(Mandatory)]$Type,
        [parameter(Mandatory)]$GpoInfo,
        $Diff,
        $Stats
    )
    # Your code goes here.
    # Anything that goes to the output stream (Out-Default) will get turned
    # into a [string] and stored as the git commit
}

function New-TrackGpoError_External {
    param(
        [parameter(Mandatory)]$Message
    )
    # Your code goes here.
    # Only gets called for stuff that prevents GPOs from getting added/compared/removed from the repo
}


# This function makes it easy to keep content at the top of my powershell window.
# It worked pretty good, but I think that I should change it to "press c to clear the console"
# or something. Got burned a few times by accidently hitting shift and *WHOOPS* console cleared.
function Enter-PresentationMode {
    function global:prompt {
        Write-Host "Press any key... ([space] to preserve)"
        $key = $Host.UI.RawUI.ReadKey('NoEcho, IncludeKeyDown')
        if ($key.character -ne " ") { Clear-Host }
        (Split-Path -Leaf $Pwd) + ">"
    }
}
