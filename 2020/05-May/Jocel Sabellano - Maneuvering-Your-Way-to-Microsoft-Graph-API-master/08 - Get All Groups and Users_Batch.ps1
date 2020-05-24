# This example demonstrates the use of sending requests in batch
# More information -> https://docs.microsoft.com/en-us/graph/json-batching

$BatchReqHeader = @{
    Authorization  = "Bearer $($TokReqRes.access_token)"
    "Content-Type" = "Application/JSON"
} 

$BatchBody = @"
{
  "requests": [
    {
      "id": "1",
      "method": "GET",
      "url": "/users"
    },
    {
      "id": "2",
      "method": "GET",
      "url": "/Groups"
    },
    {
      "id": "3",
      "method": "GET",
      "url": "/subscribedSkus"
    }
  ]
}
"@ 

$BatchRes = Invoke-RestMethod -Method POST -Uri "https://graph.microsoft.com/v1.0/`$batch" -Headers $BatchReqHeader -Body $BatchBody

$users = $BatchRes.responses | Where-Object { $_.id -eq 1 }
$users.body.value | Select-Object displayName

$Groups = $BatchRes.responses | Where-Object { $_.id -eq 2 }
$Groups.body.value | Select-Object displayName

$licenses = $BatchRes.responses | Where-Object { $_.id -eq 3 }
$licenses.body.value | Select-Object skuPartNumber, ConsumedUnits

