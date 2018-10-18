
# The Killer Pipeline

$Control = {
    Get-ChildItem -Path C:\temp | Where-Object -FilterScript { $_.Length -gt 5000 }
}

$Variation = {
    (Get-ChildItem -Path C:\temp).where({ $_.Length -gt 5000 })
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Pipelines'
