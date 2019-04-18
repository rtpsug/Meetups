function Remove-Airport {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [parameter(Mandatory)]
        [string]$City,

        [string]$DataFile = 'Airports.json'
    )
    
    begin {
        
    }    
    process {
        $Airports = Get-Content $DataFile | ConvertFrom-Json

        if ($City -in $Airports.City) {
            If ($PSCmdlet.ShouldProcess($City)) {
                $Airports | Where-Object { $_.City -ne $City } | ConvertTo-Json | Out-File $DataFile -Force
            }
        }
        else {
            throw "$City was not found in $DataFile."
        }
    }    
    end {

    }
}