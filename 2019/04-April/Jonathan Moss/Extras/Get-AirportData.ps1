function Get-AirportData {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $api = "6aa5e5d4-a0e7-4531-8d45-2852fbbc6aa7"      
    }
    
    
    process {
        Invoke-RestMethod -Method Get -Uri "https://iatacodes.org/api/v6/cities?api_key=$api" | Select-Object -ExpandProperty Response
    }
    
    end {

    }
}