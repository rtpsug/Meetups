
# We're out of Filters

$Control = {
    $Events = Get-WinEvent -LogName Application -ErrorAction SilentlyContinue |
        where {$_.Id -eq 16384 -and $_.TimeCreated -ge (Get-Date).AddHours(-1)}
}

$Variation = {
    $Events = Get-WinEvent -FilterHashTable @{
        LogName   = 'Application'
        Id        = 16384
        TimeCreated = (Get-Date).AddHours(-1)
    } -ErrorAction SilentlyContinue
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Filter Left' -Iterations 5
