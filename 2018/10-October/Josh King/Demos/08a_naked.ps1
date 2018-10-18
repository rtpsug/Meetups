
# Get Naked

$Control = {
    foreach ($i in 1..1000) {
        New-Guid
    }
}

$Variation = {
    foreach ($i in 1..1000) {
        [guid]::NewGuid()
    }
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Naked .NET'
