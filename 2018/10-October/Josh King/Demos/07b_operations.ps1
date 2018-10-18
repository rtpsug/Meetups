
# You took my liver?!

$Control = {
    $Hashtable = Import-Clixml -Path 'C:\Data\hashtable.xml'
    $Target = 'mmc6'

    foreach ($Entry in $Hashtable.Keys) {
        if ($Entry -eq $Target) {
            $true
            break
        }
    }
}

$Variation = {
    $Hashtable = Import-Clixml -Path 'C:\Data\hashtable.xml'
    $Target = 'mmc'

    $Hashtable.ContainsKey($Target)
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Unnecessary Interations'
