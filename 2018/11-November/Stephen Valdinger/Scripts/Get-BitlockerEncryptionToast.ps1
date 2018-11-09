Function Get-BitlockerEncryptionToast {

    [cmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string]
        $Computername
    )

    Begin { 
        
        If($Computername) {
            $Session = New-PSSession -ComputerName $Computername 
        }
    }
    
    Process {

        Function Get-Percentage {
        If($Computername){
        $script:EncryptionPercentage = Invoke-Command -Session $Session -ScriptBlock { (Get-BitLockerVolume).EncryptionPercentage }
        }
        Else{
            $script:EncryptionPercentage = (Get-BitLockerVolume).EncryptionPercentage
        }

        }  


        While($EncryptionPercentage -lt 100) {

            Start-Sleep -Seconds (60*5)
            Get-Percentage
        }

        $Header = New-BTHeader -Id 1 -Title "Encryption Complete!"
        New-BurntToastNotification -Text "Encryption on $Computername has completed!" -Header $Header -Silent

    }

    End { Get-PSSession | Remove-PSSession }
}