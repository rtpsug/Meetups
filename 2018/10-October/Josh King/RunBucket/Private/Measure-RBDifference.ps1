function Measure-RBDifference {
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory)]
        [double] $Control,

        [Parameter(Mandatory)]
        [double] $Variation
    )
        
    $Increase = $Variation - $Control
    $Percentage = $Increase / $Control
    $Percentage
}