## Let's use Pester to check for status code 200 and to see if Plex is operational

## Check a website and check it's http status with Pester
Describe "Invoke-RestMethod Responses" {
    
    Context "Internet Connectivity" {
        It "Google works" {
            $online = Invoke-WebRequest -URI "https://google.com"
            $online.StatusCode | Should -Be "200"
        }

        It "Plex SSO works" {
            $Plex = Invoke-RestMethod -URI "https://status.plex.tv/api/v2/status.json"
            $Plex.status.description | Should -Be "All Systems Operational"
        }
    }
}

