## Show off Assert module from @nohwnd
## Compare 2 objects

Clear-Host

$Kevin = [PSCustomObject]@{
    Age                 = 32
    KnowsPowerShell     = $true
    Languages           = 'English'
    PowershellExperienceInYears = 8
}

$Jonathan = [PSCustomObject]@{
    Age                 = 31
    KnowsPowerShell     = $true
    Languages           = 'English'
    PowershellExperienceInYears = 2
}

## Using Pester

Describe -Name "Compare 2 objects" -Fixture {
    
    It -Name "age" -Test {
        $Jonathan.age | Should -be $Kevin.Age
    }

    It -Name "powershell" -Test {
        $Jonathan.KnowsPowerShell | Should -be $Kevin.KnowsPowerShell
    }

    It -Name "languages" -Test {
        $Jonathan.Languages | Should -be $Kevin.Languages
    }

}

## Using Assert module

Assert-Equivalent -Actual $Jonathan -Expected $Kevin