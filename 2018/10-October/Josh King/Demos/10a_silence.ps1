
# Please be quiet...

$Control = {
    $Collection = New-Object -TypeName System.Collections.ArrayList

    $Random = New-Object -TypeName System.Random

    foreach ($i in 1..1000) {
        $Collection.Add($Random.Next(0,1000)) | Out-Null
    }
}

$Variation = {
    $Collection = New-Object -TypeName System.Collections.ArrayList

    $Random = New-Object -TypeName System.Random

    foreach ($i in 1..1000) {
        $null = $Collection.Add($Random.Next(0,1000))
    }
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Silencing Output'
