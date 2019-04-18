Clear-Host

. .\Get-Airport.ps1

Describe -Name "Null or Empty Tests" -Fixture {

    It -Name "RDU doesn't have any awards" -Test {
        (Get-Airport -City "Raleigh").Awards | Should -BeNullOrEmpty
    }
    
}