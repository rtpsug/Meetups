function Get-GpoValue ([xml]$GpoReport) {
    (Select-Xml -Xml $GpoReport -XPath "//*[local-name()='DropDownList']/*[local-name()='Name'][text()='Configure automatic updating:']/../*[local-name()='Value']/*[local-name()='Name']/text()").node.Value
}

$Results = New-Object System.Collections.ArrayList
$Gpos = Get-GPO -All

foreach ($Gpo in $Gpos) {
    [xml]$GpoReport = Get-GPOReport -ReportType Xml -Name $Gpo.DisplayName
    $PolSetting = Get-GpoValue -GpoReport $GpoReport

   $ObjProps = @{
    "Name" = $Gpo.DisplayName;
    "PolicySetting" = $PolSetting
   }
   
    $null = $Results.Add($ObjProps)
}

$Results