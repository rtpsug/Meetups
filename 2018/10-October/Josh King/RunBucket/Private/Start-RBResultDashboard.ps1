function Start-RBResultDashboard {
    [CmdletBinding()]

    param (
        [Parameter(Mandatory)]
        [PSCustomObject] $ControlResult,

        [Parameter(Mandatory)]
        [PSCustomObject] $VariationResult,

        [Parameter(Mandatory)]
        [PSCustomObject] $Difference,

        [Parameter()]
        [string] $Title
    )

    $DashTitle = 'RunBucket Test Results'

    if ($Title) {
        $DashTitle += " - $Title"
    }

    $Dashboard = {
        New-UDDashboard -Title $DashTitle -NavBarColor '#FF1c1c1c' -NavBarFontColor "#FF55b3ff" -BackgroundColor "#FF333333" -FontColor "#FFFFFF" -Content {
            New-UDRow {
                if ($Difference.Average -lt 0) {
                    $ConText = "Control`r`n "
                    $VarText = "Variation`r`n(Winner)"
                    $ConBgColour = '#8B0000'
                    $VarBgColour = '#006400'
                } else {
                    $ConText = "Control`r`n(Winner)"
                    $VarText = "Variation`r`n "
                    $ConBgColour = '#006400'
                    $VarBgColour = '#8B0000'
                }
                New-UDColumn -Size 4 {
                    New-UDCard -Text $ConText -TextAlignment center -BackgroundColor $ConBgColour -FontColor '#FFFFFF' -Watermark long_arrow_right -TextSize Large
                }
                New-UDColumn -Size 4 {
                    New-UDCard -Text $VarText -TextAlignment center -BackgroundColor $VarBgColour -FontColor '#FFFFFF' -Watermark random -TextSize Large
                }
            }
            New-UDRow {
                New-UDColumn -Size 4 {
                    New-UDCounter -Title 'Minimum (ms)' -Format '0,0.000' -Icon 'chevron_down' -TextAlignment center -BackgroundColor '#252525' -FontColor "#FFFFFF" -TextSize Large -Endpoint {
                        $ControlResult.Minimum | ConvertTo-Json
                    }
                }
                New-UDColumn -Size 4 {
                    New-UDCounter -Title 'Minimum (ms)' -Format '0,0.000' -Icon 'chevron_down' -TextAlignment center -BackgroundColor '#252525' -FontColor "#FFFFFF" -TextSize Large -Endpoint {
                        $VariationResult.Minimum | ConvertTo-Json
                    }
                }
                New-UDColumn -Size 4 {
                    if ($Difference.Minimum -lt 0) {
                        $BgColour = '#006400'
                    } else {
                        $BgColour = '#8B0000'
                    }

                    New-UDCounter -Title 'Difference' -Format '0.00 %' -Icon 'percent' -TextAlignment center -BackgroundColor $BgColour -FontColor "#FFFFFF" -TextSize Large -Endpoint {
                        $Difference.Minimum | ConvertTo-Json
                    }
                }
            }
            New-UDRow {
                New-UDColumn -Size 4 {
                    New-UDCounter -Title 'Maximum (ms)' -Format '0,0.000' -Icon 'chevron_up' -TextAlignment center -BackgroundColor '#252525' -FontColor "#FFFFFF" -TextSize Large -Endpoint {
                        $ControlResult.Maximum | ConvertTo-Json
                    }
                }
                New-UDColumn -Size 4 {
                    New-UDCounter -Title 'Maximum (ms)' -Format '0,0.000' -Icon 'chevron_up' -TextAlignment center -BackgroundColor '#252525' -FontColor "#FFFFFF" -TextSize Large -Endpoint {
                        $VariationResult.Maximum | ConvertTo-Json
                    }
                }
                New-UDColumn -Size 4 {
                    if ($Difference.Maximum -lt 0) {
                        $BgColour = '#006400'
                    } else {
                        $BgColour = '#8B0000'
                    }

                    New-UDCounter -Title 'Difference' -Format '0.00 %' -Icon 'percent' -TextAlignment center -BackgroundColor $BgColour -FontColor "#FFFFFF" -TextSize Large -Endpoint {
                        $Difference.Maximum | ConvertTo-Json
                    }
                }
            }
            New-UDRow {
                New-UDColumn -Size 4 {
                    New-UDCounter -Title 'Average (ms)' -Format '0,0.000' -Icon 'chevron_right' -TextAlignment center -BackgroundColor '#252525' -FontColor "#FFFFFF" -TextSize Large -Endpoint {
                        $ControlResult.Average | ConvertTo-Json
                    }
                }
                New-UDColumn -Size 4 {
                    New-UDCounter -Title 'Average (ms)' -Format '0,0.000' -Icon 'chevron_right' -TextAlignment center -BackgroundColor '#252525' -FontColor "#FFFFFF" -TextSize Large -Endpoint {
                        $VariationResult.Average | ConvertTo-Json
                    }
                }
                New-UDColumn -Size 4 {
                    if ($Difference.Average -lt 0) {
                        $BgColour = '#006400'
                    } else {
                        $BgColour = '#8B0000'
                    }

                    New-UDCounter -Title 'Difference' -Format '0.00 %' -Icon 'percent' -TextAlignment center -BackgroundColor $BgColour -FontColor "#FFFFFF" -TextSize Large -Endpoint {
                        $Difference.Average | ConvertTo-Json
                    }
                }
            }
        }
    }

    $ResultsDashboard = Get-UDDashboard

    if ($ResultsDashboard) {
        $ResultsDashboard | Stop-UDDashboard
    }

    $null = Start-UDDashboard -Content $Dashboard

    $Global:Selenium.Navigate().Refresh()
}
