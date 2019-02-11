## SID for SomeUserName
## S-1-5-21-987654321-1123456789-0321654987-1450
$userName = "DomainUser"
$userSid = (Get-ADUser -Identity $userName).SID
$computername = "__SERVERNAME__"

$xpath= "Event[ System[ EventID=7002  ] and EventData[ Data[@Name='UserSId']='$userSid' ] ]"






$xpath = @"
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[System[TimeCreated[@SystemTime&gt;='2017-07-14T10:41:35.000Z' and @SystemTime&lt;='2017-07-14T11:41:35.999Z']]]</Select>
  </Query>
</QueryList>
"@

## Applicatino - Error - Waring - Critical
$xpath = @"
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
  </Query>
</QueryList>
"@

$xpath = @"
<QueryList>
  <Query Id="0" Path="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational">
    <Select Path="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational">*</Select>
  </Query>
</QueryList>
"@

## LOGON
## EventID 7001
$servers = 51..60 | %{ "__SERVERPREFIX__$_"}
Get-WinEvent -ComputerName $servers -FilterXPath $xpath -LogName system | Tee-Object -Variable data
$servers | Invoke-Parallel { 
    $computername = $_
    Write-Verbose "Processing $computername"
    Get-WinEvent -LogName System -ComputerName $computername -FilterXPath $xpath -MaxEvents 100 -ErrorAction SilentlyContinue -Verbose

} -ImportVariables | Tee-Object -Variable Data
$data
$data | Sort-Object -Property TimeCreated | Select -Last 30 -Property TimeCreated,MachineName,Message |  Format-Table -AutoSize
$data | Sort-Object -Property TimeCreated  | Select -Property TimeCreated,MachineName,Message | Format-Table
$data | Select -Property TimeCreated,MachineName,Message| ogv
$data | Select -Property TimeCreated,MachineName,Message | group MachineName -NoElement

$days = 3


## LOGOFF
## EventID 7002


#region Get-Logon & Logoff Events
$userName = "DomainUser"
$userSid = (Get-ADUser -Identity $userName | Select -ExpandProperty SID).Value
$servers = Get-XAServer -ServerName __SERVERPREFIX__* | select -ExpandProperty ServerName |  Sort
$Servers = "__SERVERNAME__"
$servers = 51..63 | % {"__SERVERPREFIX__$_"}
#region Find log events
$data = $null
$servers | Invoke-Parallel { 
    $computername = $_
    Write-Verbose "Processing $computername"
    $events = Get-WinEvent -LogName System -ComputerName $computername `
        -FilterXPath "Event[ System[ (EventID=7001 or EventID=7002) ] and EventData[ Data[@Name=`"UserSId`"]=`"$using:UserSID`" ] ]" `
        -MaxEvents 50 -ErrorAction SilentlyContinue
    $events | % {
        $Logon = $null
        $logoff = $null
        IF ( $_.ID -eq "7001" ) {
            $Logon = $_.TimeCreated
        }
        IF ( $_.ID -eq "7002" ) {
            $logoff = $_.TimeCreated
        }
        [PSCustomObject] @{
            "Username"=$Using:userName;
            "ComputerName"=$computername;
            "Time"=$_.timeCreated;
            "Logon"=$logon;
            "Logoff"=$logoff
        }
    }
} | Tee-Object -Variable Data
$data
$data | Sort-Object -Property Time | Select -Last 30 |  Format-Table -AutoSize
$data | Where-Object Computername -EQ "__SERVERNAME__" | Format-Table
#endregion


#region Get-Logon & Logoff Events   - SECURITY LOGS
$userName = "domainuser"
$userSid = Get-ADUser -Identity $userName | Select -ExpandProperty SID
$servers = Get-XAServer -ServerName __SERVERPREFIX__* | select -ExpandProperty ServerName |  Sort
$Servers = "__SERVERNAME__"


#region Collect Logon/Logoff/Recoonect/Disconnect events  (all Users)
$servers | Invoke-Parallel { 
    $computername = $_
    Write-Verbose "Processing $computername" -Verbose
    $loginevents = Get-WinEvent -LogName Security -ComputerName $computername `
        -FilterXPath "Event[ System[ (EventID=4634 or EventID=4624 or EventID=4778 or EventID=4779) ] ]" `
        -MaxEvents 15000 -ErrorAction SilentlyContinue
#    $events = Get-WinEvent -LogName Security -ComputerName $computername `
#        -FilterXPath "Event[ System[ (EventID=4634 or EventID=4624) ] and EventData[ Data[@Name=`"UserSId`"]=`"$UserSID`" ] ]" `
#        -MaxEvents 50 -ErrorAction SilentlyContinue
    $loginevents | % {
        $Logon = $null
        $disconnect = $null
        $reconnect = $null
        $logoff = $null
        IF ( $_.ID -eq "4624" ) {
            $Logon = $_.TimeCreated
        }
        IF ( $_.ID -eq "4779" ) {
            $disconnect = $_.TimeCreated
        }
        IF ( $_.ID -eq "4778" ) {
            $reconnect = $_.TimeCreated
        }
        IF ( $_.ID -eq "4634" ) {
            $logoff = $_.TimeCreated
        }

        [PSCustomObject] @{
            "Username"=$_.Properties[1].Value;
            "ComputerName"=$computername;
            "Time"=$_.timeCreated;
            "ID"=$_.ID;
            "Logon"=$logon;
            "Disconnect"=$disconnect;
            "Reconnect"=$reconnect;
            "Logoff"=$logoff;

            "RAWData"=$_
        }
    }
} | Tee-Object -Variable Data
$data= $null
$data | Sort-Object -Property Time | Format-Table -AutoSize
$data | Where-Object Computername -EQ "__SERVERNAME__" | Format-Table
#endregion





#region Find log events
$servers | Invoke-Parallel { 
    $computername = $_
    Write-Verbose "Processing $computername" -Verbose
    Write-Verbose "Processing $($using:userName)" -Verbose
    Write-Verbose "Processing $($using:UserSID)" -Verbose
    $loginevents = Get-WinEvent -LogName Security -ComputerName $computername `
        -FilterXPath "Event[ System[ (EventID=4634 or EventID=4624) ] and EventData[ Data[@Name=`"TargetUserSid`"]=`"$($($using:UserSID).Value)`" ] ]" `
        -MaxEvents 15000 -ErrorAction SilentlyContinue
#    $events = Get-WinEvent -LogName Security -ComputerName $computername `
#        -FilterXPath "Event[ System[ (EventID=4634 or EventID=4624) ] and EventData[ Data[@Name=`"UserSId`"]=`"$UserSID`" ] ]" `
#        -MaxEvents 50 -ErrorAction SilentlyContinue
    $loginevents | % {
        $Logon = $null
        $disconnect = $null
        $reconnet = $null
        $logoff = $null
        IF ( $_.ID -eq "4624" ) {
            $Logon = $_.TimeCreated
        }
        IF ( $_.ID -eq "4779" ) {
            $disconnect = $_.TimeCreated
        }
        IF ( $_.ID -eq "4778" ) {
            $reconnect = $_.TimeCreated
        }
        IF ( $_.ID -eq "4634" ) {
            $logoff = $_.TimeCreated
        }

        [PSCustomObject] @{
            "Username"=$userName;
            "ComputerName"=$computername;
            "Time"=$_.timeCreated;
            "Logon"=$logon;
            "Disconnect"=$disconnect;
            "Reconnect"=$reconnet;
            "Logoff"=$logoff;
            "RAWData"=$_
        }
    }
} | Tee-Object -Variable Data
$data= $null
$data | Sort-Object -Property Time | Format-Table -AutoSize
$data | Where-Object Computername -EQ "_SERVERNAME_" | Format-Table
#endregion


#region Find Disconnect/Reconnect events
$servers | Invoke-Parallel { 
    $computername = $_
    Write-Verbose "Processing $computername" -Verbose
    $connectevents = Get-WinEvent -LogName Security -ComputerName $computername `
        -FilterXPath "Event[ System[ (EventID=4778 or EventID=4779) ] ]" `
        -MaxEvents 150 -ErrorAction SilentlyContinue
    $connectevents | % {
        $Logon = $null
        $disconnect = $null
        $reconnet = $null
        $logoff = $null
        IF ( $_.ID -eq "4624" ) {
            $Logon = $_.TimeCreated
        }
        IF ( $_.ID -eq "4779" ) {
            $disconnect = $_.TimeCreated
        }
        IF ( $_.ID -eq "4778" ) {
            $reconnect = $_.TimeCreated
        }
        IF ( $_.ID -eq "4634" ) {
            $logoff = $_.TimeCreated
        }

        [PSCustomObject] @{
            "Username"=$_.Properties.value[0];
            "ComputerName"=$computername;
            "Time"=$_.timeCreated;
            "Logon"=$logon;
            "Disconnect"=$disconnect;
            "Reconnect"=$reconnet;
            "Logoff"=$logoff;
            "RAWData"=$_
        }
    }


} | Tee-Object -Variable Data
$data= $null
$data | Sort-Object -Property Time | Format-Table -AutoSize
$data | Where-Object Computername -EQ "__SERVERNAME__" | Format-Table -AutoSize
#endregion




#endregion

$xPath = "Event[ System[ (EventID=7001 or EventID=7002) ] and EventData[ Data[@Name=`"UserSId`"]=`"$UserSID`" ]  ]"
Get-WinEvent -LogName System -ComputerName $computername -FilterXPath $xPath

$xpath = '*[System[(EventID=7001 or EventID=7002) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]'

$events = $servers | % { Write-verbose "$_" -Verbose; Get-WinEvent -LogName System -ComputerName $_ -FilterXPath $xPath -MaxEvents 10 -ErrorAction SilentlyContinue} 
$events | Select TimeCreated,MachineName,ID,@{Name='SID';E={([xml]$_.toxml()).event.EventData.Data[1]."#text"}} | sort TimeCreated
