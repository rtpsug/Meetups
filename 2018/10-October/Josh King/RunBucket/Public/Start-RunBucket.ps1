function Start-RunBucket {
    [CmdletBinding(DefaultParameterSetName = 'GUI')]

    param (
        [Parameter(Mandatory)]
        [scriptblock] $Control,

        [Parameter(Mandatory,
                   ParameterSetName = 'GUI')]
        [scriptblock] $Variation,

        [Parameter(Mandatory,
                   ParameterSetName = 'Console')]
        [switch] $Console,

        [Parameter()]
        [string] $Title,

        [Parameter()]
        [int] $Iterations = 100
    )

    if ($Console) {
        $Results = foreach ($i in 1..50) {
            Measure-Command $Control | select -ExpandProperty TotalMilliseconds
        }

        $Results[1..($RunTime.Results-2)] | Measure-Object -Average -Maximum -Minimum | 
            Select @{Name = 'Minimum'; Expression = {[Math]::Round($_.Minimum, 2)}},
                   @{Name = 'Maximum'; Expression = {[Math]::Round($_.Maximum, 2)}}, 
                   @{Name = 'Average'; Expression = {[Math]::Round($_.Average, 2)}}
    } else {
	    $Runtime = [System.Diagnostics.Stopwatch]::StartNew()
	    $ControlResult = Start-TestCaseMeasurement -ScriptBlock $Control -Throttle 25 -Iterations $Iterations
        Start-Sleep -Milliseconds 50
        $VariationResult = Start-TestCaseMeasurement -ScriptBlock $Variation -Throttle 25 -Iterations $Iterations
	    $Runtime.Stop()
	    
        $Difference = [PSCustomObject] @{
            Minimum = Measure-RBDifference -Control $ControlResult.Minimum -Variation $VariationResult.Minimum
            Maximum = Measure-RBDifference -Control $ControlResult.Maximum -Variation $VariationResult.Maximum
            Average = Measure-RBDifference -Control $ControlResult.Average -Variation $VariationResult.Average
        }

        $Params = @{
            ControlResult = $ControlResult
            VariationResult = $VariationResult
            Difference = $Difference
        }

	    $ToastTitle = 'RunBucket Finished'
	    
        if ($Title) {
            $Params.Add('Title', $Title)
	    	$ToastTitle += ":`n$Title"
        }

        Start-RBResultDashboard @Params
	    
	    # $AppLogo = Get-ChildItem -Path $PSScriptRoot\..\Media\Stopwatch.png
	    # $RuntimeText = 'All tests completed in {0} seconds' -f [Math]::Round($Runtime.Elapsed.TotalSeconds, 2)
        # 
        # $Text1 = New-BTText -Content $ToastTitle
        # $Text2 = New-BTText -Content $RuntimeText
        # 
        # $Image1 = New-BTImage -Source $AppLogo -AppLogoOverride -Crop Circle
        # 
        # $Audio1 = New-BTAudio -Silent
        # 
        # $Binding1 = New-BTBinding -Children $Text1, $Text2 -AppLogoOverride $Image1
        # 
        # $Visual1 = New-BTVisual -BindingGeneric $Binding1
        # 
        # $Content1 = New-BTContent -Audio $Audio1 -Visual $Visual1 -ActivationType Protocol -Launch 'http://localhost' -Duration Long
        # 
        # Submit-BTNotification -Content $Content1
    }
}
