Clear-Host

Describe -Name "Best airports in the USA" -Fixture {

    ## Source: https://www.cntraveler.com/galleries/2014-11-24/the-best-and-worst-airports-in-america-readers-choice-awards-2014
    
    $BestAirports = @("BWI", "IAH", "DFW", "PHX", "DTW", "TPA", "MSP", "BDL", "PDX", "IND")

    It -Name "RDU is the one of the best airports" -Test {
        $expected = "RDU"
        $BestAirports | Should -Contain $expected
    }
}