## Link to REST API documentation: https://github.com/Tautulli/Tautulli/blob/master/API.md
$EndpointURL = Get-Content "$ENV:HOME/Presentations/RestAPI/baseuri.txt"

## API Key for Tautulli
$apikey = ((Import-Clixml "$ENV:HOME/Presentations/RestAPI/tautulli_api.cred")).GetNetworkCredential().Password

## Command
$command = "get_activity"

## URL
$BaseURI = "$($endpointURL)apikey=$apikey&cmd=$command"

## What method we'll be using
$Method = "GET"

## Returning data
$output = (Invoke-RestMethod -Uri $BaseURI -Method $Method).response.data

Clear-Host

## Loop through each Plex stream and output some information
foreach ($thing in $output.sessions) {
    Write-host "Friend: $($thing.user)"
    Write-host "Movie: $($thing.full_title)"
    Write-Host "Device: $($thing.device)"
    Write-Host "Quality: $($thing.video_full_resolution)"
    Write-Host "`n"
}