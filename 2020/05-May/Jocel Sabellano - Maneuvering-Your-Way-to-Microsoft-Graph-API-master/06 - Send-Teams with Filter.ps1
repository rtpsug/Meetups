# This is a sample code that demonstrates the use of filter parameters. 
# More info about query paramters -> https://docs.microsoft.com/en-us/graph/query-parameters
# This also demonstrates sending a message to teams. 

# The access token being used here is from the Authorization code example. 

$ReqHeader = @{
  Authorization  = "Bearer $($TokReqRes.access_token)"
  "Content-type" = "application/json"
} 

# Get the Team ID, using serverside filtering using URL parameters
$TeamInfo = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/groups?`$filter=displayname eq 'hikers heaven'" -Method Get -Headers $ReqHeader
$TeamID = $TeamInfo.value | select-object -ExpandProperty  ID

# Get the Channel ID, using serverside filtering using URL parameters
$ChannelInfo = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/teams/$TeamID/channels?`$filter=displayname eq 'Patagonia'" -Method Get -Headers $ReqHeader
$ChannelID = $ChannelInfo.value | select-object -ExpandProperty  ID

# Body of your message
$body = @"
{
  "body": {
    "content": "what's up, Brad!? Hey!"
  }
}
"@


# Send message to the channel in TEams
$teamsURI = "https://graph.microsoft.com/v1.0/teams/$TeamID/channels/$ChannelID/messages"

Invoke-RestMethod -Headers $ReqHeader -Body $body -Uri $teamsURI -Method post