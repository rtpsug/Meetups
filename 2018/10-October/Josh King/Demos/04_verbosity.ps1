
# Being Verbose Saves Time

$Control = {
    $Services = Service | ? Status -eq Running | select -F 5
}

$Variation = {
    $Services = Get-Service | Where-Object Status -eq Running | Select-Object -First 5
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Verbosity'
