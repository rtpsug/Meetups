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
  #Add-Type -Path 'C:\Program Files\WindowsPowerShell\Modules\BurntToast\0.6.2\lib\Microsoft.Toolkit.Uwp.Notifications\Microsoft.Toolkit.Uwp.Notifications.dll'
  $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
  $null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
  
  $ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::new()
  
  $ToastXml.LoadXml($XmlString)
  
  $Toast = [Windows.UI.Notifications.ToastNotification]::new($ToastXml)
  
  [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)

}