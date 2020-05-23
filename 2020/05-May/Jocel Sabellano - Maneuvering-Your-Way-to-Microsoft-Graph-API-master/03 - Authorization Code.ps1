#Authorization Code
<# 
http://bit.ly/2K4vmVG

Workflow: 
1. You access a URL with necessary parameters
2. You authenticate in the browser
3. You get a code upon successfull authentication
4. You Send the code to token request endpoint with other needed information
5. You get token
6. you talk to Graph API with your token

With right permissions and admin grant or user authorization, this is the flow for Authorization_Coe:
1. To acquire an Authorization code:
    1.1 using SDKs or by simply going to this URL in a browser (new line for legibility): 
        https://login.microsoftonline.com/{tenantID}/oauth2
            /v2.0/authorize?client_id={clientID}
            &redirect_uri={RedirectURI}&scope={Scope}
            &response_type=code
    1.2 Upon successul authentication, you will get code in the URL. Like this: https://monosnap.com/file/p8GwA4CciZqFXzICUgQeCEq7J94sZN
    1.3 Extract that code and save it to Variable
2. With all those other needed information, wrap them in variable to be the header for token request. IN my case its the $reqTokenBody
3. YOu send the $reqTokenBody to token request endpoint. What's in the token body are the the basic requirements in Authorization_Code header.
4. YOu get the access token
5. You save the access the token in a variable $ReqHeader to proper format it (Bearer pre-fix and "AUthorization" value name)
6. Use $reqheader as the Header for your request to Graph API endpoint
 
#>

$TenantID = "8ffdf9c1-9116-4da9-b7c4-928b095b1fac"
$ClientID = "8e7890a2-3e89-43b3-b742-8d53b928a3cc"
$ClientSecret = "509rJ1doOJF@kcXqHx[TcdlNA=BTE=AV"

$redirectUri = "https://google.com"
$scope = "https://graph.microsoft.com/Directory.Read.All Group.ReadWrite.All Sites.ReadWrite.All offline_Access"
# Get AuthCode

# Browse this URL in internet explorer. 
$url = "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/authorize?client_id=$clientid&redirect_uri=$redirectUri&scope=$scope&response_type=code&prompt=consent"
$ie = New-Object -com internetexplorer.application
$ie.visible = $true
$ie.navigate2($url)

# Wait for the authentication to finish. 
while ($ie.document.url -notmatch "session_state") {   
    Start-Sleep -Seconds 2
    if ($ie.document.url -match "error=consent") {
        Write-host "Error on Authentication"
        Break
    }

}

# capture the Auth Code in the URL
$authCode = (($ie.document.url -split "&")[0] -split "=")[1]
$ie.quit()

#get Access Token using our AuthCode
$ReqTokenBody = @{
    redirect_uri  = $redirectUri 
    Grant_Type    = "authorization_code"
    client_Id     = $ClientID 
    Client_Secret = $ClientSecret
    Scope         = $scope 
    code          = $authCode
} 

$TokReqRes = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

$ReqHeader = @{
    Authorization = "Bearer $($TokReqRes.access_token)"
} 


# Sending to Graph, sample code to get all groups. 
$allGroups = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/groups" -Method Get -Headers $ReqHeader
$allGroups.value | Select-Object displayName



