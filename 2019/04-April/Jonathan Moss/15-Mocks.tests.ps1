## http://jakubjares.com/2017/12/19/using-because/

Clear-Host

Describe 'Health check' {
    
    Function Get-Service { }

    # mock is here only to make the example work
    Mock Get-Service { [PSCustomObject]@{ Status = 'Stopped' } }

    It 'is protected by antivirus' {
        $service = Get-Service -Name AntivirusService
        $running = [ServiceProcess.ServiceControllerStatus]::Running

        $service.Status | Should -Be $running -Because 'antivirus must be running to protect our computer'
    }
}