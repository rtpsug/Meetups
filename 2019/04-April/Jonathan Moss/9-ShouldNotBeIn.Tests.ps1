Clear-Host

Describe -Name 'End of Week Flying Check' -Fixture {

    $Weekend = "Friday", "Saturday", "Sunday"

    It "Okay to fly today" {
        (Get-Date).DayOfWeek | Should -Not -BeIn $Weekend -Because "flying on the weekend is a bad idea"
    }
}   