. C:\EvetLogs\Scrub.ps1

Get-Help Get-WinEvent -ShowWindow

Get-WinEvent -LogName Application 

Get-WinEvent -LogName Application -MaxEvents 20 

Get-WinEvent -LogName Application -MaxEvents 20  | Get-Member



$EventHash = @{
    LogName='Application'
    ProviderName='MSiInstaller'
    ID='1024'
}

Get-WinEvent -FilterHashtable $EventHash | Scrub-Data -OutVariable MSiInstallerEvents


<#
Get-WinEvent  -FilterHashTable Key-Value Pairs

    KeyName      DataType Wildcard
    -------      -------- --------
    LogName      String[] Yes
    ProviderName String[] Yes
    Path         String[] No
    Keyworks     Long     No
    ID           Int32    No
    Level        Int32    No
    StartTime    DateTime No
    EndTime      DateTime No
    UserId       SID      No
    Data         String[] No
    *            String[] No
#>


$MSiInstallerEvents[1] | fl *


[xml]$eventXML = $MSiInstallerEvents[1].ToXml() | Scrub-Data

$eventXML
$eventXML.Event.EventData.Data

$MSiInstallerEvents | % {
    [xml]$currEvtXML = $_.toxml() | Scrub-Data
    [PSCustomObject]@{
        AppName = $currEvtXML.Event.EventData.Data[0]
        GUID = $currEvtXML.Event.EventData.Data[1]
        ErrorCode = $currEvtXML.Event.EventData.Data[2]
    }
}| ft -AutoSize

$eventXML.Event.System
