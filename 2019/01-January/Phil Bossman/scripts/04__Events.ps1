Break
. C:\EvetLogs\Scrub.ps1
Get-Help Get-WinEvent -ShowWindow

Get-WinEvent -ComputerName localhost -LogName Application

Get-WinEvent -ComputerName localhost -LogName Application  -MaxEvents 50


eventvwr.exe



## Find Non-informational within 7 Days events on server
$XMLFilter = @"
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(Level=1  or Level=2 or Level=3) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
  </Query>
</QueryList>
"@


Get-WinEvent -LogName Application -FilterXPath $XMLFilter



# find Errors with EventID 7000 or 7022
$XMLFilter = @"
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[System[(Level=2) and (EventID=7000 or EventID=7022)]]</Select>
  </Query>
</QueryList>
"@

# Find Interactive events on Citrix server
$LogName = "Application"
$XMLFilter = @"
<QueryList>
  <Query Id="0" Path="$LogName">
    <Select Path="$LogName">*[System[Provider[@Name='Interactive Services detection']]]</Select>
  </Query>
</QueryList>
"@

# Find Interactive Errors on Citrix server
$LogName = "Application"
$eventID = 1508
$XMLFilter = @"
<QueryList>
  <Query Id="0" Path="$LogName">
    <Select Path="$LogName">*[System[(Level=2) and (EventID=$eventID)]]</Select>
  </Query>
</QueryList>
"@

$systems = "__SERVERNAME__"
$systems = $XASErver -like "__SERVERPREFIX__*"
$systems = 1..8 | %{ "__SERVERPREFIX__$_"}


### THIS IS PRESTAGED
$Systems | %{
    $currSystem = $_
    Get-WinEvent -ComputerName $currSystem -LogName $LogName -FilterXPath $XMLFilter -ErrorAction SilentlyContinue
} | Tee-Object -Variable Events 
## PreSTAGE WORK
$events | Scrub-Data
$events | Export-Clixml .\InteractiveErrors.xml

## HYDRATE PRESTAGED Data
$events = Import-Clixml .\InteractiveErrors.xml
$events | select -First 1
$events | select -First 1 -ExpandProperty message
$events | select MachineName,TimeCreated,Message
$events | sort Timecreated | select MachineName,TimeCreated,Message
$events | sort TimeCreated | FT



