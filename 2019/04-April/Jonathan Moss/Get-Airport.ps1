function Get-Airport {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, mandatory = $true)]    
        [string]$City
    )

    switch ($City) {
        "Raleigh" {
            @{
                Name        = "Raleigh-Durham International Airport"
                Code        = "RDU"
                Website     = "https://www.rdu.com"
                PhoneNumber = "919-840-2123"
                Airlines    = @(
                    'Delta',
                    'Southwest',
                    'Alaska Airlines',
                    'Allegiant',
                    'Air Canada',
                    'American Airlines',
                    'Frontier',
                    'JetBlue',
                    'Spirit',
                    'United'
                )
                Awards = ""
            }
        }
        "Phoenix" {
            @{
                Name        = "Phoenix Sky Harbor International Airport"
                Code        = "PHX"
                Website     = "https://www.skyharbor.com"
                PhoneNumber = "602-273-3300"
                Airlines    = @(
                    'Advanced Air',
                    'Air Canada',
                    'Alaska Airlines',
                    'American Airlines',
                    'Boutique Air',
                    'British Airways',
                    'Condor Airlines',
                    'Delta',
                    'Frontier',
                    'Hawaiian',
                    'Jet Blue',
                    'Southwest',
                    'Spirit',
                    'Sun Country',
                    'United',
                    'Volaris',
                    'WestJet'
                )
                Awards = ""
            }
        }
        Default {
            Throw "Try another city! I can't find that one."
        }
    }
}