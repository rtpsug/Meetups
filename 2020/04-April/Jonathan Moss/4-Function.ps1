function Send-GMMessage {
    [CmdletBinding()]
    param (
        [string]
        $Text,

        [PSCredential]
        $API = (Import-Clixml "$ENV:Temp\apitoken.cred")
    )

    $body = @{
        text   = $Text
        bot_id = $API.UserName
    }
        
    $json = $body | ConvertTo-Json
        
    $splat = @{
        URI    = "https://api.groupme.com/v3/bots/post?Token={0}" -f $API.GetNetworkCredential().Password
        Method = "POST"
        Body   = $json
    }
        
    Invoke-RestMethod @splat

}

## Send-GMMessage -Text "This is being recorded lol"