Clear-Host

. .\Get-Airport.ps1

Describe -Name "Raleigh Airport Code" -Fixture {
    
    $Actual = Get-Airport -City "Raleigh"

    It -Name "Raleigh Code is accurate" -Test {
        $Expected = "RDU"
        $Actual.Code | Should -Be $Expected -Because "Raleigh's airport is named RDU"
    }

}
