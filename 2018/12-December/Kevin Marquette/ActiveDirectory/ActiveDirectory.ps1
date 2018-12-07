#region Demo prep
$cred = Get-Credential -UserName administrator -Message DomainAdmin
$server = '172.29.144.2'
$PSDefaultParameterValues["*-AD*:Server"] = $Server
$PSDefaultParameterValues["*-AD*:Credential"] = $cred
Start-VM Demo-DC
Test-NetConnection $Server

#endregion

$ADUsers  = Get-ADUser -Filter * -Properties memberof,department,title -SearchBase 'OU=Demo Accounts,DC=demo,DC=local'
$ADGroups = Get-ADGroup -Filter * -SearchBase 'OU=Groups,OU=Demo Accounts,DC=demo,DC=local'
$ADUsers  | ogv
$ADGroups | ogv



graph ADUsers @{rankdir='LR'} {

    Node $ADGroups -NodeScript {$_.DistinguishedName} -Attributes @{
        label={$_.Name}
        shape='box'
        style='filled'
        color='green'
    }

    Node $ADUsers -NodeScript {$_.DistinguishedName} -Attributes @{
        label={'{0}\n{1}\n{2}' -f $_.Name,$_.title,$_.department }
        shape='box'
    }    
    
    ForEach ($group in $ADGroups)
    {
        $members = Get-ADGroupMember $group | where DistinguishedName
        If($null -ne $members)
        {
            Edge -From $members.DistinguishedName -To $group.DistinguishedName
        }
    }
} | Export-PSGraph -ShowGraph




ForEach($group in $ADGroups)
{
    $graph = graph ActiveDirectory @{rankdir='LR'} {
        Node @{shape='box'}
        $groupMembers = Get-ADGroupMember $group
        If($null -ne $groupMembers)
        {
            Edge -From $groupMembers.Name -To $group.Name
            Node $groupMembers -NodeScript {$_.name} @{
                URL   = {"/$($_.Name).html"}
                color = 'green'
            }
        }

        $memberOf = Get-ADPrincipalGroupMembership $group
        If($null -ne $memberOf)
        {
            Edge -From $group.Name -To $memberOf.Name
            Node $memberOf -NodeScript {$_.name} @{
                URL   = {"/$($_.Name).html"}
                color = 'blue'
            }
        }
    }
    
    $graph | Export-PSGraph -DestinationPath web\$($group.Name).png
    $graph | Export-PSGraph -OutputFormat cmapx -DestinationPath web\$($group.Name).map

    "<IMG SRC='$($group.Name).png' USEMAP='#ActiveDirectory' />" | Set-Content -Path web\$($group.Name).html
    Get-Content web\$($group.Name).map | Add-Content -Path web\$($group.Name).html
}


docker run --name PSGraph-demo --volume=$($PWD)/web:/usr/share/nginx/html:ro -d -p 8080:80 nginx
Start 'http://localhost:8080/Consulting.html'