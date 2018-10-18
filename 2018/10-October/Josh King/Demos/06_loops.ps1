
# Going Loopy

$Control = {
    $TotalLength = 0

    Get-ChildItem -Path C:\temp\ | foreach {
        $TotalLength += $_.Length
    }
}

$Variation = {
    $TotalLength = 0

    $Items = Get-ChildItem -Path C:\temp\

    foreach ($Item in $Items) {
        $TotalLength += $Item.Length
    }
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Loops'
