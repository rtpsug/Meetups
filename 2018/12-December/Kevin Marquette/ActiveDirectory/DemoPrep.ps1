#region Demo prep
$cred = Get-Credential -UserName administrator -Message DomainAdmin
$server = '172.29.144.2'
$PSDefaultParameterValues["*-AD*:Server"] = $Server
$PSDefaultParameterValues["*-AD*:Credential"] = $cred
Start-VM Demo-DC
Test-NetConnection $Server
#https://gallery.technet.microsoft.com/scriptcenter/Create-UsersGroup-for-9ee1de26
.\CreateDemoUsers.ps1 -Server $Server
Import-Module NameIt
$ADUsers = Get-ADUser -Filter * -SearchBase 'OU=Demo Accounts,DC=demo,DC=local'
$newGroups = Invoke-Generate "[synonym action]_[synonym unit]" -Count 7
foreach($groupName in $newGroups)
{
    $random = Get-Random -Minimum 2 -Maximum 4
    $group = New-ADGroup -Name $groupName -Path 'OU=Groups,OU=Demo Accounts,DC=demo,DC=local' -GroupScope DomainLocal -GroupCategory Security -PassThru
    Add-ADGroupMember -Identity $group -Members ($ADUsers | Get-Random -Count $random)
}

$newGroups = Invoke-Generate "[synonym action]_[synonym committee]" -Count 15
foreach($groupName in $newGroups)
{
    $random = Get-Random -Minimum 2 -Maximum 5
    $group = New-ADGroup -Name $groupName -Path 'OU=Groups,OU=Demo Accounts,DC=demo,DC=local' -GroupScope DomainLocal -GroupCategory Security -PassThru
    $ADGroups = Get-ADGroup -Filter * -SearchBase 'OU=Groups,OU=Demo Accounts,DC=demo,DC=local'
    Add-ADGroupMember -Identity $group -Members ($ADGroups | Get-Random -Count $random)
}

#endregion
