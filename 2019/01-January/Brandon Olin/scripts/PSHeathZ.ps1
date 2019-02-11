
$listener = Start-HealthZListener -Port 8080 -Path 'health' -PassThru
$tests = Invoke-RestMethod -Uri 'http://localhost:8080/health'
$tests.availableTests

$results = Invoke-RestMethod -Uri 'http://localhost:8080/health?module=*'
