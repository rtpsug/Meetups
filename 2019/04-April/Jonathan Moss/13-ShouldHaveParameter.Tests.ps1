Clear-Host

. .\Get-Airport.ps1

Describe -Name "Validating parameters on Get-Airport" -Fixture {
    
    It -Name "has a string parameter called city" -Test {
        Get-Command "Get-Airport" | Should -HaveParameter City -Type String
    }
}