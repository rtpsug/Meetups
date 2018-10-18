function Start-ConsoleRunBucket {
    [CmdletBinding()]

    param (
        [Parameter(Mandatory)]
        [scriptblock] $TestCase,

        [Parameter()]
        [int] $Iterations = 10
    )

    $RunTime = foreach ($i in 1..$Iterations) {
        (Measure-Command $TestCase).TotalMilliseconds
    }

    $Result = $RunTime | Measure -Average -Maximum -Minimum

    [PSCustomObject] @{
        Minimum = $Result.Minimum
        Maximum = $Result.Maximum
        Average = $Result.Average
    }
}
