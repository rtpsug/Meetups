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