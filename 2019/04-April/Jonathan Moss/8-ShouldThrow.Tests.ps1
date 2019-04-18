Clear-Host

. .\Get-Airport.ps1

Describe -Name "Throw stuff" -Fixture {
    
    It -Name "Throw!" -Test {
        { Get-Airport -City "Los Angeles" } | Should -Throw -Because "I haven't added that one"
    }
    
}