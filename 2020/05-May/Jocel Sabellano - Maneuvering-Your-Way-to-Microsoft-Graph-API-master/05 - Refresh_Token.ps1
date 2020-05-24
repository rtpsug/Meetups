#Region Refresh_Token Grant
<# Refresh_Token Grant
http://bit.ly/2K4vmVG
http://bit.ly/2RzwYYx

If you add "offline_access" (e.g.g https://graph.microsoft.com/reports.read.all offline_access)in to your scope when requesting a token,
    it will add refresh token to your result.
    You can use this refresh token to request for another access token. 

1. request a token and add "offline_acceess" to scope
2. use the refresh token to request another access token. The logic in your app may include a way to do math in terms of the expiration of the access token. 
    Know that fresh token expires in xx days (I'm not sure TBH but it says here 90 days http://bit.ly/2REqCHs) - access tokens expire in 1 hour when it was generated. 
3. The access token acquired from the refresh token can be used the same fashion as the rest of the grant types
    #>

# DO NOT PUT SECRETS/PASSWORDS IN SOURCE CODE, THIS IS FOR DEMO ONLY!

$TenantID = "8ffdf9c1-9116-4da9-b7c4-928b095b1fac"
$ClientID = "8e7890a2-3e89-43b3-b742-8d53b928a3cc"


$ReqTokenBody = @{
    Grant_Type    = "Refresh_Token"
    client_Id     = $ClientID
    Refresh_TOken = $TokReqRes.refresh_token
}

$TokReqRes = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

$ReqHeader = @{
    Authorization = "Bearer $($TokReqRes.access_token)"
} 

$allSKUs = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/subscribedSkus" -Method Get -Headers $ReqHeader
$allSKUs.value | Select-Object skuPartNumber, ConsumedUnits
#EndRegion Refresh_Token Grant