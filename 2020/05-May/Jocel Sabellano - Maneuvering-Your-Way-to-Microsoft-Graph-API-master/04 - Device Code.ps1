#Region Device Code FLow
<# Device Code
http://bit.ly/2Xs06X2

Workflow: 
1. You send needed information to device code endpoint
2. You get an authentication code for authentication and a device code for token request
3. you get to a URL (Provided in the message property of the result) on any device and authenticate using 
4. You send needed information to Token request endpoint and you get token if you have authenticated succesfully in step 3.
5. you talk to Graph API with your token

With right permissions and admin grant or user authorization, this is the flow for Device_code:
1. Send $DevReqBody to deviceCode endpoint to request
2. You will receive a device code, an authentication code, and a URL in which you'll be able to authenticate. 
3. You browse to the URL and provide the authentication code and authenticate. 
4. You grab the Device code from Step 2 and along with the information in $reqTokenBody, send it to Token Request endpoint. 
5. You get the access token
6. You save the access the token in a variable $ReqHeader to proper format it (Bearer pre-fix and "AUthorization" value name)
7. Use $reqheader as the Header for your request to Graph API endpoint
#>


# Request device code for authentication

# DO NOT PUT SECRETS/PASSWORDS IN SOURCE CODE, THIS IS FOR DEMO ONLY!

$TenantID = "8ffdf9c1-9116-4da9-b7c4-928b095b1fac"
$ClientID = "8e7890a2-3e89-43b3-b742-8d53b928a3cc"
$scope = "https://graph.microsoft.com/Directory.Read.All offline_Access"


$DevReqBody = @{ 
    Client_ID = $ClientID 
    Scope     = $scope
}
$DevReqRes = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/devicecode" -Body $DevReqBody

$DevReqRes.message

# Do not proceed after this line without authentication. Else, codes below won't work. 
# In your script, you can also add wait logic. 
# Token Request
$ReqTokenBody = @{
    Grant_Type = "urn:ietf:params:oauth:grant-type:device_code"
    client_Id  = $ClientID
    Code       = $DevReqRes.device_code
}

$TokReqRes = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

$ReqHeader = @{
    Authorization = "Bearer $($TokReqRes.access_token)"
} 

# Sending to Graph, sample code to get all license. 
$allSKUs = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/subscribedSkus" -Method Get -Headers $ReqHeader
$allSKUs.value | Select-Object skuPartNumber, ConsumedUnits
