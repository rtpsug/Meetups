$EggsButton = New-BTButton -Content 'Eggs' -Arguments 'ToastPS:Eggs'
$HeartButton = New-BTButton -Content 'Heart' -Arguments 'ToastPS:Heart'
$RawButton = New-BTButton -Content 'Raw' -Arguments 'ToastPS:Raw'

$Splat = @{
    Text    = "Your Wallpaper Is Boring", "Please pick a new one!"
    AppLogo = 'C:\ToastDemo\Images\wallpaper-icon.png'
    Sound   = 'IM'
    Button  = $EggsButton, $HeartButton, $RawButton
}

New-BurntToastNotification @Splat 
