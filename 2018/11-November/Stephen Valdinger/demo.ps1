#region Engine Events
#Powershell Exiting Events. This executes in a different Scope, so if BurntToast is in your current sessionstate,
#it won't be available to the event.
#Explicitly import the nodule to "force" the Event to see the module
Import-Module BurntToast

Register-EngineEvent -SourceIdentifier Powershell.Exiting -Action {

    $Header = New-BTHeader -Id 1 -Title "Powershell Exit"

    New-BurntToastNotification -Text "Whatever you were doing is done, and Powershell exited" -Header $Header -Silent

}


Register-EngineEvent -SourceIdentifier Test -Action { Toast -Header (New-BTHeader -Id 1 -Title "Engine Event Test") -Text "$($event.MessageData)" } > $null

New-Event -SourceIdentifier Test -Sender PowershellTesting -MessageData "Way better than 'Write-Verbose', no?!" >$null

#endregion

#region Alert
$buttonProps = @{
    Id = 1
    Content = 'View Alerting Metric'
    Arguments = 'https://play.grafana.org/d/000000052/advanced-layout?panelId=2&fullscreen&orgId=1'
}

$button = New-BTButton @buttonProps

$header = New-BTHeader -Id 1 -Title 'Service Degradation Alert'

$toastProps = @{
    Button = $button
    Text = "There's an issue. Click 'View Alerting Metric' to View"
    Header = $header
    AppLogo = 'C:\Github\RTPSUG7Nov\Images\grafana.png'
}

New-BurntToastNotification @toastProps
#endregion

#region Reminder
Function New-ToastReminder {

    [cmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0)]
        [string]
        $ReminderTitle,

        [Parameter(Mandatory, Position = 1)]
        [string]
        $ReminderText,

        [Parameter(Position = 2)]
        [int]
        $Seconds,

        [Parameter(Position = 3)]
        [Int]
        $Minutes,

        [Parameter(Position = 4)]
        [Int]
        $Hours
    )

    Begin {}

    Process {

        Start-Job -ScriptBlock {
                        
            $watch =  [System.Diagnostics.Stopwatch]::New()
            $watch.Start()
            
            $HoursToSeconds = $using:Hours * 60  * 60
            $MinutesToSeconds = $using:Minutes * 60
            $TotalSeconds = $HoursToSeconds + $MinutesToSeconds + $using:Seconds
            
            While ($watch.Elapsed.TotalSeconds -lt $TotalSeconds) {

                Out-Null
            }

            $watch.Stop()

            $Head = New-BTHeader -ID 1 -Title $using:ReminderTitle
            Toast -Text $using:ReminderText -Header $Head -AppLogo $null

        } > $null
    }

    End {}

}

New-ToastReminder -ReminderTitle "Pssssst!" -ReminderText "You need to get eggs on the way home" -Seconds 10
#endregion

#region Encryption
Function Get-BitlockerEncryptionToast {

    [cmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string]
        $Computername
    )

    Begin { 
        
        If($Computername) {
            $Session = New-PSSession -ComputerName $Computername 
        }
    }
    
    Process {

        Function Get-Percentage {
        If($Computername){
        $script:EncryptionPercentage = Invoke-Command -Session $Session -ScriptBlock { (Get-BitLockerVolume).EncryptionPercentage }
        }
        Else{
            $script:EncryptionPercentage = (Get-BitLockerVolume).EncryptionPercentage
        }

        }  


        While($EncryptionPercentage -lt 100) {

            Start-Sleep -Seconds (60*5)
            Get-Percentage
        }

        $Header = New-BTHeader -Id 1 -Title "Encryption Complete!"
        New-BurntToastNotification -Text "Encryption on $Computername has completed!" -Header $Header -Silent

    }

    End { Get-PSSession | Remove-PSSession }
}
#endregion

#region Toner Levels

#Generate a fake dataset
$tonerLevels = [pscustomobject]@{

    Black = 100
    Cyan = 25
    Magenta = 66
    Yellow = 5
}

$tonerLevels.PSObject.Members | Where-Object { $_.MemberType -eq "NoteProperty"} | ForEach-Object {

    If($_.Value -lt 10) {

        $Header = New-BTHeader -Id 1 -Title "Toner Alert for $($_.Name)"

        New-BurntToastNotification -Header $Header -Text "$($_.Name) has $($_.Value)% Remaining!"

    }

}

#endregion

#region Tee-Object clone
function New-ToastyOutput {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]
        $InputObject,

        [Parameter(Mandatory)]
        [String]
        $Source,

        [Parameter(Mandatory)]
        [Int]$Id

    )

    Begin {
        Import-Module BurntToast
    }
    Process {

        If (Get-EventLog -LogName Application -Source $Source -ErrorAction SilentlyContinue) {
            Write-EventLog -LogName Application -Source $Source -Message $InputObject -EventId $Id
        }

        Else {
            New-EventLog -LogName Application -Source $Source -ErrorAction SilentlyContinue
            Write-EventLog -LogName Application -Source $Source -Message $InputObject -EventId $Id
        }

        New-BurntToastNotification -Text "$InputObject" -Header (New-BTHeader -Id 1 -Title $Source)
    }

}

$string = "Some dummy text"

New-ToastyOutput -InputObject $string -Source TeeToast -Id 222

Get-EventLog -LogName Application -Source TeeToast

#endregion

#region DotNet
Function New-DotNetToast {
    [cmdletBinding()]
    Param(
        
        [Parameter(Mandatory, Position = 0)]
        [String]
        $Title,
        [Parameter(Mandatory,Position = 1)]
        [String]
        $Message,
        [Parameter(Position = 2)]
        [String]
        $Logo = "C:\Program Files\WindowsPowerShell\Modules\BurntToast\0.6.2\Images\BurntToast.png"
       
  
    )
  
  
    $XmlString = @"
    <toast>
      <visual>
        <binding template="ToastGeneric">
          <text>$Title</text>
          <text>$Message</text>
          <image src="$Logo" placement="appLogoOverride" hint-crop="circle" />
        </binding>
      </visual>
      <audio src="ms-winsoundevent:Notification.Default" />
    </toast>
"@
    
    
    $AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
    $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    $null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
    
    $ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::new()
    
    $ToastXml.LoadXml($XmlString)
    
    $Toast = [Windows.UI.Notifications.ToastNotification]::new($ToastXml)
    
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)
  
  }

  New-DotNetToast -Title 'Hellow @RTPSUG!' -Message "How did you like this demo? Questions?"

#endregion