
# Let's Chat About Chatter

$Control = {
    Get-ChildItem -Path 'C:\Windows\System32\drivers' -Recurse
}

$Variation = {
    $Items = Get-ChildItem -Path 'C:\Windows\System32\drivers' -Recurse
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Console Chatter'
