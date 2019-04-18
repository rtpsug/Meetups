Clear-Host

. .\Get-Airport.ps1

Describe -Name "Function Output" -Fixture {

    It -Name "Get-Airport Outputs a Hashtable" -Test {
        $Output = Get-Airport -City "Raleigh"
        $Output | Should -BeOfType System.Collections.Hashtable
    }

}