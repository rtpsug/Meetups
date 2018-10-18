
# Like... *Really* Naked

$Control = {
    $RootPath = 'C:\Data'

    foreach ($i in 1..1000) {
        Join-Path -Path $RootPath -ChildPath $i
    }
}

$Variation = {
    $RootPath = 'C:\Data'

    foreach ($i in 1..1000) {
        [IO.Path]::Combine($RootPath, $i)
    }
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Naked Paths'
