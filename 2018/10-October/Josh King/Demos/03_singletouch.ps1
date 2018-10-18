
# Stop Poking Me!

$Control = {
    $AppEvents = Get-WinEvent -FilterHashTable @{
        LogName = 'Application'
        Id      = 16384
    } -ErrorAction SilentlyContinue

    $SysEvents = Get-WinEvent -FilterHashTable @{
        LogName = 'System'
        Id      = 7001
    } -ErrorAction SilentlyContinue
}

$Variation = {
    $Events = Get-WinEvent -FilterHashTable @{
        LogName = 'Application', 'System'
        Id      = 16384, 7001
    } -ErrorAction SilentlyContinue

    $AppEvents = $Events.where({$_.LogName -eq 'Application'})

    $SysEvents = $Events.where({$_.LogName -eq 'System'})
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Single Touch'
