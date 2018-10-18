#requires -version 5.0
#requires -module PSTeachingTools

#create an HTML report
Param([string]$Path = ".\veggies.htm")

$veg = Get-Vegetable | Group-object -Property CookedState

$fragments = "<H1> Vegetable Report <H1>"
foreach ($item in $veg) {

    $fragments+= "<h2>$($item.name) [$($item.count)]</h2>"
    $fragments+= $item.group | 
    Select-object -property UPC,Name,Count,Color,Is* |
    Convertto-Html -Fragment

}

$params = @{
    Body = $fragments 
    CssUri = "C:\scripts\sample.css"
    Title = "Vegetable Report"
}

ConvertTo-Html @params | Out-File -FilePath $path

#view the file
# start $path