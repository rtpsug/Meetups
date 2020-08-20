$Button = New-BTButton -Content 'Picture' -Arguments 'C:\ToastDemo\Images\Josh-King.jpg'

$Splat = @{
    Text    = "This Toast Is a Little Useless", "Click the button to open a picture"
    AppLogo = 'C:\ToastDemo\Images\bored-icon.png'
    Sound   = 'IM'
    Button  = $Button
}

New-BurntToastNotification @Splat 
