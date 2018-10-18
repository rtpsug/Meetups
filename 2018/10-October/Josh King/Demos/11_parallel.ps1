
# Get a (PoshRS)Job!

$Control = {
    $Targets = @('8.8.8.8','8.8.4.4','1.1.1.1','1.0.0.1','stuff.co.nz')

    foreach ($Target in $Targets) {
        $Response = Test-Connection -ComputerName $Target -Count 2 -Quiet

        [PSCustomObject] @{
            Host = $Target
            Online = $Response
        }
    }
}

$Variation = {
    $Targets = @('8.8.8.8','8.8.4.4','1.1.1.1','1.0.0.1','stuff.co.nz')

    $Targets | Start-RSJob -Name {$_} -ScriptBlock {
        $Response = Test-Connection -ComputerName $_ -Count 2 -Quiet

        [PSCustomObject] @{
            Host = $_
            Online = $Response
        }
    } | Wait-RSJob | Receive-RSJob
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Parallel Job' -Iterations 5
