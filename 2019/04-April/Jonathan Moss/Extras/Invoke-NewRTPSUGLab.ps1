$labName = 'RTPSUG'

#create an empty lab template and define where the lab XML files and the VMs will be stored
New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

#make the network definition
Add-LabVirtualNetworkDefinition -Name $labName -AddressSpace 192.168.81.0/24

Set-LabInstallationCredential -Username Install -Password Somepass1

#and the domain definition with the domain admin account
Add-LabDomainDefinition -Name test1.net -AdminUser Install -AdminPassword Somepass1

#the first machine is the root domain controller. Everything in $labSources\Tools get copied to the machine's Windows folder
Add-LabMachineDefinition -Name S1DC1 -Memory 1024MB -Network $labName -IpAddress 192.168.81.10 `
    -DnsServer1 192.168.81.10 -DomainName test1.net -Roles RootDC `
    -IsDomainJoined -ToolsPath $labSources\Tools -OperatingSystem 'Windows Server 2016 Datacenter Evaluation (Desktop Experience)'

#the second just a member server. Everything in $labSources\Tools get copied to the machine's Windows folder
Add-LabMachineDefinition -Name S1Server1 -Memory 1024MB -Network $labName -IpAddress 192.168.81.20 `
    -DnsServer1 192.168.81.10 -DomainName test1.net -IsDomainJoined -ToolsPath $labSources\Tools `
    -OperatingSystem 'Windows Server 2016 Datacenter Evaluation (Desktop Experience)'

Install-Lab

Show-LabDeploymentSummary -Detailed