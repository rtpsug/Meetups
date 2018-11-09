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