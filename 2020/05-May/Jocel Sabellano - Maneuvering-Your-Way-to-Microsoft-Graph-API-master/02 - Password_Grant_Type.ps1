<# Password Grant
# http://bit.ly/2K4TWFP

A little similar to client_Credentials but with username and password in the header of the token request. 

Workflow: 
1. You send needed information to token request Endpoint (with username and password)
2. You get token
3. you talk to Graph API with your token

With right permissions and admin grant or user authorization, this is the flow for CLient_Credentials:
1. You send the $reqTokenBody to token request endpoint. What's in the token body are the the basic requirements in Client_Credentials header.
2. You get the access token
3. You save the access the token in a variable $ReqHeader to proper format it (Bearer pre-fix and "AUthorization" value name)
4. Use $reqheader as the Header for your request to Graph API endpoint

#>

# DO NOT PUT SECRETS/PASSWORDS IN SOURCE CODE, THIS IS FOR DEMO ONLY!

$TenantID = "8ffdf9c1-9116-4da9-b7c4-928b095b1fac"
$ClientID = "8e7890a2-3e89-43b3-b742-8d53b928a3cc"
$ClientSecret = "509rJ1doOJF@kcXqHx[TcdlNA=BTE=AV"
$Username = "test.a@theitrx.com"
$Password = "Rp59b4#x"

# Information about  offline_access in scope -> https://bit.ly/2XjTh7N
$ReqTokenBody = @{
    Grant_Type    = "Password"
    client_Id     = $ClientID
    Client_Secret = $ClientSecret
    Username      = $Username
    Password      = $Password
    Scope         = "https://graph.microsoft.com/Directory.Read.All offline_access"
} 


$TokReqRes = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

$ReqHeader = @{
    Authorization = "Bearer $($TokReqRes.access_token)"
} 

# Sending to Graph, sample code to get all groups. 
$allGroups = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/groups" -Method Get -Headers $ReqHeader
$allGroups.value | Select-Object displayName


