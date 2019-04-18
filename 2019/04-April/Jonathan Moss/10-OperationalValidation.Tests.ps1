## Operational Validation

Clear-Host

. .\Get-Airport.ps1

Describe -Name "Get-Airport tests" -Fixture {
    
    Context -Name "Website Status" -Fixture {

        It -Name "RDU website online" {
            $actual = (Invoke-WebRequest -Uri (Get-Airport -City "Raleigh").Website).StatusCode
            $expected = "200"
            $actual | Should -Be $expected
        }

        It -Name "PHX website online" {
            $actual = (Invoke-WebRequest -Uri (Get-Airport -City "Phoenix").Website).StatusCode
            $expected = "200"
            $actual | Should -Be $expected
        }
    
        BeforeAll -Scriptblock {
            Write-host "I run before any of the it blocks" -ForegroundColor DarkCyan
        }
    
        AfterAll -Scriptblock {
            Write-host "I run after any of the it blocks" -ForegroundColor DarkCyan
        }

    }
   
}