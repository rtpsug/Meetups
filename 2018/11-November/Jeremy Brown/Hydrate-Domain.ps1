$Domain = Get-ADDomain
$Depts = @('HR', 'FIN', 'SALES', 'IT')
$SubOUs = @('Computers', 'Groups', 'Servers')
$Names = Get-Content 'C:\names.txt'

function Hydrate-OUs() {
    New-ADOrganizationalUnit -Name 'People' -Path $Domain.DistinguishedName

    foreach ($Dept in $Depts) {
        New-ADOrganizationalUnit -Name $Dept -Path $Domain.DistinguishedName
        $DeptOU = Get-ADOrganizationalUnit -Filter {name -eq $Dept}
        foreach ($SubOU in $SubOUs) {
            New-ADOrganizationalUnit -Name $SubOU -Path $DeptOU.DistinguishedName
        }
    }
}

function Hydrate-Users() {
    for ($i=0; $i -lt 250000; $i++) {
        $RootOU = 'OU=People,DC=posh,DC=demo'
        $UserDept = Get-Random -InputObject $Depts
        $UserSuff = (Get-Random -Minimum 1 -Maximum 9999).ToString("0000")
        $UserGivenName = Get-Random -InputObject $Names
        $UserSurname = Get-Random -InputObject $Names
        $UserSAM = $UserGivenName + $UserSuff
        $Password = ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force

        $UserExists = [bool](Get-ADUser -Filter {SamAccountName -eq $UserSAM})

        if ($UserExists -eq $false) {
            $Params = @{
                "Name" = $UserSAM
                "GivenName" = $UserGivenName
                "Surname" = $UserSurname
                "SamAccountName" = $UserSAM
                "AccountPassword" = $Password
                "Department" = $UserDept
                "ChangePasswordAtLogon" = $false
                "Enabled" = $true
                "Path" = $RootOU
            }
            New-ADUser @Params
        }
    }
}

function Hydrate-Computers() {
    for ($i=0; $i -lt 20000; $i++) {
        $CompDept = Get-Random -InputObject $Depts
        $DeptOU = Get-ADOrganizationalUnit -Filter {Name -eq $CompDept}
        $CompOU = "OU=Computers," + $DeptOU.DistinguishedName
        $CompName = $CompDept + (Get-Random -Minimum 1 -Maximum 999999).ToString("000000")
        
        $CompExists = [bool](Get-ADComputer -Filter {Name -eq $CompName})

        if ($CompExists -eq $false) {
            $Params = @{
                "Name" = $CompName
                "SamAccountName" = $CompName
                "Path" = $CompOU
                "Enabled" = $true
            }
            New-ADComputer @Params
        }
    }
}