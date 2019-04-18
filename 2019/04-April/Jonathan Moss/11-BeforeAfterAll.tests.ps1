## Pester https://github.com/pester/Pester/tree/v5.0 

Clear-Host

Describe "Show off BeforeAll and AfterAll" {
    Write-Host Running Describe

    BeforeAll {
        Write-Host Running BeforeAll
    }

    It "i" {
        Write-Host Running It
    }

    AfterAll {
        Write-Host Running AfterAll
    }
    
    Write-Host Leaving Describe
}