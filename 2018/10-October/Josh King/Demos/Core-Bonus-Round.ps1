Start-ConsoleRunBucket -Iterations 10 -TestCase {
    foreach ($i in 1..10000) { New-Guid }
}


Start-ConsoleRunBucket -Iterations 100 -TestCase {
    $Collection = New-Object -TypeName System.Collections.ArrayList

    $Random = New-Object -TypeName System.Random

    foreach ($i in 1..50000) {
        $null = $Collection.Add($Random.Next(0,1000))
    }
}


Start-ConsoleRunBucket -Iterations 100 -TestCase {
    1..1000 | % {Get-Random -Minimum 1 -Maximum 100} | Group-Object
}


Start-ConsoleRunBucket -Iterations 1 -TestCase {
    1..100000 | % {Get-Random -Minimum 1 -Maximum 10000} | Group-Object
}
