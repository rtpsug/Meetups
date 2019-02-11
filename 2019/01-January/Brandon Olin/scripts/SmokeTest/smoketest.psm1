
function Invoke-SmokeTest {
    [PoshBot.BotCommand(
        CommandName = 'SmokeTest'
    )]
    [cmdletbinding()]
    param(
        [string]$ComputerName = 'localhost',
        [int]$Port = 8080,
        [string]$Path = 'health',
        [string]$Module = '*'
    )

    $uri = 'http://{0}:{1}/{2}?module={3}' -f $ComputerName, $Port, $Path, $Module
    $results = Invoke-RestMethod -Uri $uri

    $type = 'Normal'
    if (-not $results.success) {
        $type = 'Error'
    }

    $title  = "Smoke test for [$ComputerName]"
    $total  = $results.testResults.Count
    $failed = ($results.testResults | Where-Object {$_.passed -ne $true}).Count
    $text   = "[$failed] tests failed of total [$total] executed`n"
    $text   += $results.testResults |
        Where-Object {$_.passed -eq $false} |
        Select-Object -Property describe, context, passed, test |
        Format-List |
        Out-String -Width 80

    New-PoshBotCardResponse -Type $type -Title $title -Text $text
}

Export-ModuleMember -Function Invoke-SmokeTest