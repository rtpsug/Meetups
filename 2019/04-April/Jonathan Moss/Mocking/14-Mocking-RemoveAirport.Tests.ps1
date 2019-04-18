Clear-Host

. .\Remove-Airport.ps1

Describe -Name "Remove-Airport tests" -Fixture {

    Mock -CommandName Out-File -MockWith { }

    Context "Valid airport" {

        It -Name "Should return null" -Test {
            Remove-Airport -City 'Raleigh' | Should -Be $null
        }    
        It -Name "Should invoke Out-File to remove a valid airport" -Test {
            Assert-MockCalled -CommandName Out-File -Times 1 -Exactly
        }
    }
    
    Context "Invalid airport" {

        It -Name "Should throw an exception when removing an invalid airport" -Test {
            { Remove-Airport -City 'FakeTown' } | Should -Throw
        }
        It -Name "Should not invoke Out-File when removing an invalid airport" -Test { 
            Assert-MockCalled -CommandName Out-File -Times 0 -Exactly
        }
    }

    Context "Valid airport with -WhatIf" {

        It -Name "Should return null" -Test {
            Remove-Airport -City 'Raleigh' -WhatIf | Should -Be $null
        }
        It -Name "Should not invoke Out-File when using -WhatIf" -Test {  
            Assert-MockCalled -CommandName Out-File -Times 0 -Exactly
        }
    }
}

