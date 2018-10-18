
# Becoming a Hoarder

$Control = {
    $Collection = New-Object -TypeName System.Collections.ArrayList

    $Random = New-Object -TypeName System.Random

    foreach ($i in 1..1000) {
        $null = $Collection.Add($Random.Next(0,1000))
    }
}

$Variation = {
    $Random = New-Object -TypeName System.Random

    $Collection = foreach ($i in 1..1000) {
        $Random.Next(0,1000)
    }
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Collections Continued'
