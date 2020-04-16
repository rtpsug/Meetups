## Link to REST API documentation: https://dev.groupme.com/docs/v3

## Base URI 
$BaseURI = "https://api.groupme.com/v3"

## What method we'll be using
$Method = "POST"

## the "endpoint", or what we're targeting 
$Endpoint = "/bots/post"

## The text that we're sending in the body of the web request
$Text = "Also, I love you guys."

## The username and password (username being the bot_id and password being the token)
$API = (Import-Clixml "$ENV:HOME/Presentations/RestAPI/apitoken.cred")

$Body = @{
    text = $Text
    bot_id = $api.username
}

## Posting to GroupMe
Invoke-RestMethod -Method $Method -Uri ($BaseURI + $Endpoint + "?Token=" + $API.GetNetworkCredential().Password) -Body ($body | ConvertTo-Json) 