. C:\EvetLogs\Scrub.ps1

Get-WinEvent -ComputerName $servers[1] -ListLog Mic* | sort LogName,RecordCount

$logName = "Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational"
$xpath = @"
<QueryList>
  <Query Id="0" Path="$LogName">
    <Select Path="$LogName">*[System[TimeCreated[timediff(@SystemTime) &lt;= 2592000000]]]</Select>
  </Query>
</QueryList>
"@

#region list WebAppServers
    $servers = 51..58 | % {"__SERVERPREFIX__$_"}
    $servers | Invoke-Parallel { Get-WinEvent -ComputerName $_ -LogName $logName -FilterXPath  $xpath } -OutVariable AllWebAppLogonEvents -ImportVariables
    $AllWebAppLogonEvents | Scrub-Data
    $AllWebAppLogonEvents | Export-Clixml .\WebAppsSvrs.xml
#endregion
$AllWebAppLogonEvents = Import-Clixml .\WebAppsSvrs.xml


## Application Error - DWM.exe
$xpath = @"
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(Level=2) and (EventID=1000)] and  EventData[ Data='DWM.exe' ]]</Select>
  </Query>
</QueryList>
"@

## Application Error - AppName.exe
$appName = "Receiver.exe"
$xpath = @"
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(Level=2) and (EventID=1000)] and  EventData[ Data='$appName' ]]</Select>
  </Query>
</QueryList>
"@


#region list ERP Servers
$servers = 51..64 | % {"__SERVERPREFIX__$_"}
$servers | Invoke-Parallel  { Get-WinEvent -ComputerName $_ -LogName $logName -FilterXPath  $xpath } -OutVariable AllERPRAWEvents -ImportVariables
$AllERPErrorEvents | Scrub-Data
$AllERPRAWEvents | Scrub-Data
$AllERPErrorEvents | Export-Clixml .\ERP_AppError.xml
#endregion
$AllERPErrorEvents = IMport-Clixml .\ERP_AppError.xml


$AllERPErrorEvents.Count

$AllERPErrorEvents[2]

$AllERPErrorEvents[2]| fl *
$AllERPErrorEvents | where message -notlike "*EXCEL.exe*"
$AllERPErrorEvents | where message -notlike "*EXCEL.exe*"

$AllERPRAWEvents[2].Toxml() | Scrub-Data

$AllERPRAWEvents[2]

## build your Own XPath Query
## "Application Error" events Evnt ID 1000
$xpath = @"
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(Level=2) and (EventID=1000)]]</Select>
  </Query>
</QueryList>
"@
Get-WinEvent -logname Application -FilterXPath $xpath | Scrub-Data -OutVariable AllAppErrorEvents

$AllAppErrorEvents[2]

$AllAppErrorEvents.Count

$AllAppErrorEvents[2].ToXml() | Scrub-Data
[xml]$eventxml = $AllAppErrorEvents[2].ToXml() 
$eventxml
$eventxml.Event.EventData.Data

$AllAppErrorEvents | % {
  [xml]$xml = $_.ToXml() |Scrub-Data
      [PSCustomObject]@{
          AppName = $xml.Event.EventData.Data[0]
          Version = $xml.Event.EventData.Data[1]
          RAWData = $xml.Event
      }
} | group AppName -NoElement