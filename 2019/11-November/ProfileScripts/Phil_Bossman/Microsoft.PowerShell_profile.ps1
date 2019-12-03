if (Get-PSSnapin -Registered -Name *Citrix* -ErrorAction SilentlyContinue) {
    Write-verbose "Loading Citrix SnapIn..." -Verbose
    Add-PSSnapin *Citrix*
}
# if (Get-PSSnapin -Registered -Name *VMWare* -ErrorAction SilentlyContinue) {
#     Write-verbose "Loading VMWare SnapIn..." -Verbose
#     Add-PSSnapin *VMWare*
# }

if (Get-Command -Name Get-XAFarm -ErrorAction SilentlyContinue) {

    Write-verbose "Initializing XA 6.5 variables..." -Verbose
    $XAServer = Get-XAServer | Select -ExpandProperty ServerName | sort
    $XAApps = Get-XAApplication | Sort BrowserName
    $XAAppList = $XAApps | Select -ExpandProperty BrowserName | sort
    $XAAppDetails = $XAApps | Get-XAApplicationReport | 
        % {
            $WorkGroupServers = @(If ($_.WorkerGroupNames) { Get-XAWorkerGroupServer -WorkerGroupName $_.WorkerGroupNames -ErrorAction SilentlyContinue | Sort ServerName | select -ExpandProperty ServerName } )
            $allServers = @($_.ServerNames) + $WorkGroupServers
            [PSCustomObject] @{
                'FolderPath' = ($_.folderPath) -replace "Applications/","" ;
                'Application' = $_.BrowserName;
                'ProvisionGroups' = @($_.Accounts | Where AccountdisplayName -ne "MYDOMAIN\CitrixAdm") -join ', ' -replace 'MYDOMAIN\\','' | Sort;
                'UserAccounts' = $_.Accounts -join ', '
                'AllServers' = ($allServers | Group-ServerNames) ;
                'ServerNames' = $_.ServerNames -join ', '
                'WorkGroup' = $_.WorkerGroupNames -join ', ';
                'WGServers' = $WorkGroupServers -join ', ';
                'AppSettings' = $_
             }
        } | Sort FolderPath,ApplicationName
}
New-Alias SS Select-String

if (Get-Command -Name Get-BrokerMachine -ErrorAction SilentlyContinue) {

    $RALProd = [pscustomObject] @{'SiteName'="RALProd";'AdminAddress'="RALCTXDDC01.MYDOMAIN.com"}
    $RALQA = [pscustomObject] @{'SiteName'="RALQA";'AdminAddress'="RALCTXQADDC01.MYDOMAIN.com"}
    $DALProd = [pscustomObject] @{'SiteName'="DALProd";'AdminAddress'="DALCTXDDC01.MYDOMAIN.com"}
    $DALQA = [pscustomObject] @{'SiteName'="DALQA";'AdminAddress'="DALCTXQADDC01.MYDOMAIN.com"}
    $sites = @($RALProd,$RALQa,$DALProd,$DALQA)

    Write-verbose "Initializing XA 7.x variables..." -Verbose
    $XAServer = $sites | %{ (Get-BrokerMachine -AdminAddress $_.AdminAddress | Select -ExpandProperty MachineName) -replace "MYDOMAIN\\" }  | sort 
    $XAAppList = $sites | %{ Get-BrokerApplication -AdminAddress $_.AdminAddress | Select -ExpandProperty PublishedName }  | sort 
    $XAAppDetails = $sites | %{ Get-BrokerApplication -AdminAddress $_.AdminAddress | 
        Select PublishedName,Enabled,CommandLineExecutable, CommandLineArguments,AssociatedUserNames,AssociatedFullNames,
            @{Name="AppGroup";Expression={
                $_.AssociatedApplicationGroupUUIDs | %{ 
                Get-BrokerApplicationGroup -UUID $_ | Select -ExpandProperty Name }
             }},
            @{Name="DesktopGroup";Expression={
                $_.AssociatedDesktopGroupUUIDs | %{ 
                Get-BrokerDesktopGroup -UUID $_ | Select -ExpandProperty Name }
             }}
    }  | sort -Property PublishedName 
}
New-Alias SS Select-String

# Load posh-git example profile
if (Test-Path -Path 'C:\tools\poshgit\dahlbyk-posh-git-869d4c5\profile.example.ps1') {
    . 'C:\tools\poshgit\dahlbyk-posh-git-869d4c5\profile.example.ps1'

    Rename-Item Function:\Prompt PoshGitPrompt -Force
    function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}
}

