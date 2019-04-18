Clear-Host

. .\Get-Airport.ps1

Describe -Name "Test Cases" -Fixture {

    $cases = @(
        @{City = "Raleigh"; Name = "Raleigh-Durham International Airport" }
        @{City = "Phoenix"; Name = "Phoenix Sky Harbor International Airport" }
    )

    It "<City> exists in Get-Airport" -TestCases $cases {
        param ( $City, $Name )
        (Get-Airport -City $City).Name | Should -Be $Name
    }
}