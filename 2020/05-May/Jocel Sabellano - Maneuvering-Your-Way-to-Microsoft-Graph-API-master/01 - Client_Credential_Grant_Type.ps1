<# Client_Credentials Grant type
http://bit.ly/2K0rswY

Workflow:
1. You send needed information to Token request Endpoint
2. You get token
3. You talk to Graph API with your token

With right permissions and admin grant or user authorization, this is the flow for CLient_Credentials:
1. YOu send the $reqTokenBody to token request endpoint. What's in the token body are the the basic requirements in Client_Credentials header.
2. YOu get the access token
3. You save the access the token in a variable $ReqHeader to proper format it (Bearer pre-fix and "Authorization" value name)
4. Use $reqheader as the Header for your request to Graph API endpoint
#>

# DO NOT PUT SECRETS/PASSWORDS IN SOURCE CODE, THIS IS FOR DEMO ONLY!

$TenantID = "8ffdf9c1-9116-4da9-b7c4-928b095b1fac"
$ClientID = "8e7890a2-3e89-43b3-b742-8d53b928a3cc"
$ClientSecret = "509rJ1doOJF@kcXqHx[TcdlNA=BTE=AV"

# Info about the .default scope -> https://bit.ly/2ZrfEeg
$ReqTokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    client_Id     = $ClientID
    Client_Secret = $ClientSecret
}

$TokReqRes = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

$TokReqRes
$TokReqRes.access_token

$ReqHeader = @{
    Authorization = "Bearer $($TokReqRes.access_token)"
} 

# # Sending to Graph, Sample query on getting all users
$allUsers = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/users" -Method Get -Headers $ReqHeader
$allUsers.value | Select-Object displayName 