
# I can't hear myself think!

$Control = {
    $Collection = New-Object -TypeName System.Collections.ArrayList

    $Random = New-Object -TypeName System.Random

    foreach ($i in 1..1000) {
        $null = $Collection.Add($Random.Next(0,1000))
    }
}

$Variation = {
    $Collection = New-Object -TypeName System.Collections.ArrayList

    $Random = New-Object -TypeName System.Random

    foreach ($i in 1..1000) {
       $Collection.Add($Random.Next(0,1000)) > $null
    }
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Casting to the void'
