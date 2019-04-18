Clear-Host

Describe 'Set-ItResult Examples' {

    It 'Should ensure the API is working' {
        
        If ((Get-Date).DayOfWeek -eq 'Monday') {

            Set-ItResult -Inconclusive -Because 'API is down for maintenance on Mondays.' 
        }

        $APIResult | Should -Be 'Working'
    }
    
    It 'Should test $true is $false' {
        
        If (-not $OppositeDay) {
        
            Set-ItResult -Skipped -Because 'It is not opposite day'
        }
            
        $true | Should -Be $false        
    }

    It 'Should test version 5 of the API' {
        
        If ($APIVersion -ne 5) {
        
            Set-ItResult -Pending -Because 'API v5 not yet available for testing.'

        }
    }
}