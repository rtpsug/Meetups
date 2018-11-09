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
                        
            $watch =  New-Object -Type System.Diagnostics.Stopwatch
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