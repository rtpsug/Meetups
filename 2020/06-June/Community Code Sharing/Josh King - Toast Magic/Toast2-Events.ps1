$XmlString = @"
<toast>
  <visual>
    <binding template="ToastGeneric">
      <text>Actionable Toast?!</text>
      <text>I should be able to register an event, right?</text>
      <image src="C:\ToastDemo\Images\bored-icon.png" placement="appLogoOverride" />
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

$Toast | Get-Member -MemberType Event

Register-ObjectEvent -InputObject $Toast -EventName Activated -Action {
    Out-File -FilePath C:\Temp\Event.txt -InputObject (Get-Date -Format 'o') -Append -Force
}

[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)
