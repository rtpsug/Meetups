## https://iatacodes.org/api/v6/ENDPOINT?api_key=YOUR-API-KEY
$api = Get-Content api.json | ConvertFrom-Json | Select-Object -ExpandProperty api
$a = Invoke-WebRequest -Method Get -Uri https://iatacodes.org/api/v6/cities?api_key=$api