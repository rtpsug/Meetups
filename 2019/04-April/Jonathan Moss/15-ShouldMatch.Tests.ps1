Clear-Host

. .\Get-Airport.ps1

Describe -Name "Regex" -Fixture {
    
    ## https://stackoverflow.com/questions/16699007/regular-expression-to-match-standard-10-digit-phone-number
    $Regex = "^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$"
    
    It -Name "Airport phone number is in the correct format" -Test {
        (Get-Airport -City "Raleigh").PhoneNumber | Should -Match $Regex
    }
}