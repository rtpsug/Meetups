
# Give it back!

$Control = {
    $TxtFiles = Get-ChildItem -Path 'C:\Temp' -Recurse -Filter '*.txt'
    $Target = 'Josh'

    $TxtFiles | Get-Content | Select-String $Target
}

$Variation = {
    $TxtFiles = Get-ChildItem -Path 'C:\Temp' -Recurse -Filter '*.txt'
    $Target = 'Josh'

    $TxtFiles | Select-String $Target
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Unnecessary Searching' -Iterations 5
