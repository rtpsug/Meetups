#discover commands
get-command *vegetable*

#discover how to use them
help Get-Vegetable
help get-vegetable -full
help get-vegetable -Parameter name
help Get-Vegetable -Examples

#try them
get-vegetable

#help showed me some options
Get-Vegetable -Name carrot
Get-Vegetable -RootOnly

#PowerShell writes objects to the pipeline
get-vegetable | get-member
Get-Vegetable | Select Name,Count,CookedState

#you can do stuff
help Set-Vegetable
Get-Vegetable carrot | Set-Vegetable -Count 20
Get-vegetable carrot
Get-Vegetable carrot | Set-Vegetable -CookingState Roasted -Passthru

Get-Vegetable | Where {$_.count -le 10}
Get-Vegetable | Sort-Object -Property count -Descending
Get-Vegetable | measure-object -Property count -sum
Get-Vegetable | group-object -Property color | sort Count

Get-Vegetable | export-csv .\veg.csv
get-content .\veg.csv
$in = import-csv .\veg.csv
$in
$in | Select-object Name,Count,CookedState,color | format-table

#convert objects from json
$n = get-content .\newveg.json | ConvertFrom-Json
$n | New-Vegetable -Passthru
Get-Vegetable

#then you can script
ise .\vegreport.ps1

