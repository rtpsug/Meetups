
#region XMLFilter with ErrorMsg
$MyNumber="26"
$ErrorMessage = 'You already have an instance of this application open and are not allowed to run more than one instance. Please contact your System Administrator.'

$xmlFilter =[xml] @"
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[
        System[
            (EventID=42 or EventID=6005 or EventID=6006 or EventID=$MyNumber)
                 and 
            TimeCreated[ timediff(@SystemTime) &lt;= 60480000000 ]
        ] and 
        EventData[ 
                Data='$ErrorMessage'
        ]
    ]</Select>
  </Query>
</QueryList>
"@
#endregion

#region XMLFilter with EventID
$MyNumber="26"

$LogName = 'System'
$xmlFilter =[xml] @"
<QueryList>
  <Query Id="0" Path="$LogName">
    <Select Path="$LogName">*[
        System[
            (EventID=42 or EventID=6005 or EventID=6006 or EventID=$MyNumber)
                 and 
            TimeCreated[ timediff(@SystemTime) &lt;= 60480000000 ]
        ]
    ]</Select>
  </Query>
</QueryList>
"@
#endregion



Get-WinEvent -FilterXml $xmlFilter -ComputerName __SERVERNAME__ -ErrorAction SilentlyContinue 

