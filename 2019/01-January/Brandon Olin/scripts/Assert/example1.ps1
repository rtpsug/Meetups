function Get-ApprovedDomainAdmins {
    @('mwilliams', 'jthompson', 'kreyes')
}

function Get-ActualDomainAdmins () {
    @('mwilliams', 'jthompson', 'kreyes', 'bolin')
}

Describe 'Approved Domain Admins' {

    $actual   = Get-ActualDomainAdmins
    $approved = Get-ApprovedDomainAdmins

    It 'All Domain Administrators are approved' {
        $failMsg  = "<actualFilteredCount> unauthorized domain admin: `n'<actualFiltered>'"
        $actual   = Get-ActualDomainAdmins
        $approved = Get-ApprovedDomainAdmins
        $actual | Assert-All {$_ -in $approved} -CustomMessage $failMsg
    }
}

Describe 'Approved Domain Admins' {

    $actual   = Get-ActualDomainAdmins
    $approved = Get-ApprovedDomainAdmins

    $actual | ForEach-Object {
        It "[$_] is approved" {
            $_ -in $approved | Should -be $true
        }
    }
}