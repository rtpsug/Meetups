break

## If you know there isn't a Rest API available, use Invoke-WebRequest. It'll try and parse HTML for you
## which isn't really an API.
Invoke-WebRequest

## If you know there IS a Rest API available or you know a site publishses data using XML or JSON, use Invoke-RestMethod!
Invoke-RestMethod

## Let's get the public IP address
$ip = Invoke-RestMethod -Method Get -Uri "https://ipinfo.io/json"

## Let's find out more about the CoronaVirus from a JSON file
$covid19 = Invoke-RestMethod -Method "Get" -URI "https://pomber.github.io/covid19/timeseries.json"

# Let's filter on just today, and just for the USA
$covid19 | 
Select-object -ExpandProperty US |
Where-Object {$PSItem.date -eq (Get-Date -Format "yyyy-M-dd")}

## Let's get some kanye west jokes
Invoke-RestMethod -Method "Get" -URI "https://api.kanye.rest/"

## Maybe lets get some data about the latest SpaceX launch
$SpaceX = Invoke-RestMethod -Method "Get" -URI "https://api.spacexdata.com/v3/launches/latest"