# This is an example code that demonstrates paging in the query results. 
# More info: https://docs.microsoft.com/en-us/graph/paging


$username = "jocel.s@theITRx.com"
$Params = @{ 
    Headers = $ReqHeader
    Method  = "Get"
}

$ReqHeader = @{
    Authorization = "Bearer $($TokReqRes.access_token)"
} 

$allResults = @()
# In this example, I'm trying to get all my files in the Mydata folder in the root of my OneDrive
# It has a thousand files so it's a lot of stuff to return in one response. 
$Uri  = "https://graph.microsoft.com/v1.0/users/$username/drive/root:/MyData:/children"
$nextLinkFlag = 0

while($nextLinkFlag -ne 1){
    
    $Result = Invoke-RestMethod @params -uri $Uri

    # Check if the result has the @odata.nextLink property
    if(($result.psobject.properties | select-object -expand name) -contains '@odata.nextLink'){
        $uri = $result.'@odata.nextLink'
    }
    else{
        $nextLinkFlag = 1
    }
    $allResults += $result.value | select Name, Size
}