# Mock!
# Largely copied from https://github.com/markwragg/Presentations/blob/master/20181010_PSDayUK-2018/PesterExamples/5-MockingMissingFunctions.tests.ps1 
# Mark Wragg | https://github.com/markwragg | @markwragg

Clear-Host

. .\Get-Airport.ps1

Describe -Name "Get-Airport tests" -Fixture {
    
    Context -Name "should confirm get-aduser can be used to match users for the RDU airport" -Fixture {

        Function Get-ADUser { }
    
        Mock -CommandName Get-ADUser -MockWith {
            [PSCustomObject]@{
                DisplayName = "Michael Landguth"
                Company     = "Raleigh-Durham International Airport"
            }
        }

        It -Name "RDU Company Test" -Test {
            $User = Get-ADUser
            @(Get-Airport -City "Raleigh").Name | Should -Be $user.Company
        }
    }

    Context -Name "should confirm get-aduser can be used to match users for the Phoenix airport" -Fixture {
        Function Get-ADUser { }
    
        Mock -CommandName Get-ADUser -MockWith {
            [PSCustomObject]@{
                DisplayName = "James Bennett"
                Company     = "Phoenix Sky Harbor International Airport"
            }
        }

        It -Name "PHX Company Test" -Test {
            $User = Get-ADUser
            @(Get-Airport -City "Phoenix").Name | Should -Be $user.Company
        }
    }
    
}

Describe -Name "Date test" -Fixture {
    
    Mock Get-Culture { }

    Mock -CommandName Get-Culture -MockWith {
        [PSCustomObject]@{
            Name = "es"
            DisplayName = "Spanish"
        }
    }

    It -Name "Get-Culture should return spanish" -Test {
        (Get-Culture).DisplayName | Should -Be "Spanish"
    }
}