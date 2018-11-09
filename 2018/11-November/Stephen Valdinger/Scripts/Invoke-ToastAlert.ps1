$button = New-BTButton -Id 1 -Content 'Go' -Arguments 'https://play.grafana.org/d/000000052/advanced-layout?panelId=2&fullscreen&orgId=1'
$header = New-BTHeader -Id 1 -Title 'Service Degradation Alert'
New-BurntToastNotification -Button $button -Text "There's an issue. Click 'Go' to View" -Header $header -AppLogo 'C:\users\svalding\Pictures\Toast\grafana.png'