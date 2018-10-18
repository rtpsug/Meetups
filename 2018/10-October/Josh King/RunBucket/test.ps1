$one = {
    'test' | Out-Null
}

$two = {
    $null = 'Test'
}

Start-RunBucket -Control $one -Variation $two