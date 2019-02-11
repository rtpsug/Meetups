function Scrub-Data {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [psobject]
        $Object
    )
    
    begin {
    }
    
    process {
        Write-Verbose "Object Type: [$($Object.GetType())]" 
        if ($Object.GetType().Name -eq 'EventLogRecord' -or $Object.GetType().Name -eq 'PSObject') {
            Write-Verbose "WinEvent" 
            $editMachineName = $Object.MachineName
            $Object.PSobject.properties.remove("MachineName")
            $editMachineName = ($editMachineName -replace '.MYDOMAIN.com','.domain.local')
            $editMachineName = $editMachineName -replace '^[a-zA-Z]{5}',"___"
            $object | Add-Member -MemberType NoteProperty -Name MachineName -Value $editMachineName -Force
            $Object.Message = ($Object.Message -replace 'MYDOMAIN.com','domain.local')
            $Object.Message = ($Object.Message -replace 'MYDOMAIN\\','domain\\')
            $Object.Message = ($Object.Message -replace '192.162.','x.x.')
            $object
        }
        elseif ($Object.GetType().Name -eq 'string') {
            Write-Verbose "String" 
#            $Object = $Object -replace '([A-Za-z0-9]{5})(?<name>[a-zA-Z0-9]+)(.MYDOMAIN.com)','___${name}.domain.local'
#            $Object = ($Object -replace '.MYDOMAIN.com','.domain.local')
#            $Object = $Object -replace '([A-Za-z0-9]{4})(?<name>[a-zA-Z0-9]+)(.MYDOMAIN.com)','___${name}.domain.local'
            $object = $Object -replace '([A-Za-z0-9]{5})(?<name>[a-zA-Z0-9]+)(.MYDOMAIN.com)','___${name}.domain.local'
            $object = $Object -replace '(MYDOMAIN)','domain'
            $object = $Object -replace '(ADMINUSERNAME)','admADAcct'
            $object = $Object -replace '(USERNAME)','ADAcct'
            $object = $Object -replace '(COMPUTERNAME)','____'
            $object = $Object -replace '(xxxxxxxxxx-xxxxxxxxxx)','123456789-9999999999'
            $Object -replace 'xxxxxxxxxx-xxxxxxxxx','9999999999-123456789'

        } else {
            $Object
        }
    }
    
    end {
        
    }
}