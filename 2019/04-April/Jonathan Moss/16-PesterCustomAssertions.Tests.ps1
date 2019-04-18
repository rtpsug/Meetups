## Credit: https://mathieubuisson.github.io/pester-custom-assertions/ 

Clear-Host

Function BeInSubnet {
    <#
    .SYNOPSIS
    Tests whether an IPv4 address in the same subnet as a given address with a given subnet mask.
    #>
    [CmdletBinding()]
    Param(
        $ActualValue,
        $Network,
        $Mask,
        [switch]$Negate
    )
    If ( $ActualValue -isnot [ipaddress] ) {
        $ActualValue = $ActualValue -as [ipaddress]
    }
    If ( $Network -isnot [ipaddress] ) {
        $Network = $Network -as [ipaddress]
    }
    If ( $Mask -isnot [ipaddress] ) {
        $Mask = $Mask -as [ipaddress]
    }
    
    $ActualNetworkBinary = $ActualValue.Address -band $Mask.Address
    $ExpectedNetworkBinary = $Network.Address -band $Mask.Address
    
    [bool]$Pass = $ActualNetworkBinary -eq $ExpectedNetworkBinary
    If ( $Negate ) { $Pass = -not($Pass) }
    
    If ( -not($Pass) ) {
        $ActualSubnetString = ($ActualNetworkBinary -as [ipaddress]).IPAddressToString
        If ( $Negate ) {
            $FailureMessage = 'Expected: address {{{0}}} to be outside subnet {{{1}}} with mask {{{2}}} but was within it.' -f $ActualValue.IPAddressToString, $Network.IPAddressToString, $Mask.IPAddressToString
        }
        Else {
            $FailureMessage = 'Expected: address {{{0}}} to be in subnet {{{1}}} with mask {{{2}}} but was in subnet {{{3}}}.' -f $ActualValue.IPAddressToString, $Network.IPAddressToString, $Mask.IPAddressToString, $ActualSubnetString
        }
    }
    
    $ObjProperties = @{
        Succeeded      = $Pass
        FailureMessage = $FailureMessage
    }
    return New-Object PSObject -Property $ObjProperties
}

Add-AssertionOperator -Name 'BeInSubnet' -Test $Function:BeInSubnet

Describe 'BeInSubnet assertions' {
    Context 'Assertions on [string] objects' {

        It '"10.1.5.193" should be in the same subnet as "10.1.5.0" with mask "255.255.255.0"' {
            '10.1.5.193' | Should -BeInSubnet -Network '10.1.5.0' -Mask '255.255.255.0'
        }
        It '"10.1.5.0" should be in the same subnet as "10.1.5.0" with mask "255.255.255.0"' {
            '10.1.5.0' | Should -BeInSubnet -Network '10.1.5.0' -Mask '255.255.255.0'
        }
        It '"10.1.5.193" should be in the same subnet as "10.1.5.0" with mask "255.0.0.0"' {
            '10.1.5.193' | Should -BeInSubnet -Network '10.1.5.0' -Mask '255.0.0.0'
        }
        It '"10.1.5.193" should not be in the same subnet as "10.1.5.0" with mask "255.255.255.128"' {
            '10.1.5.193' | Should -Not -BeInSubnet -Network '10.1.5.0' -Mask '255.255.255.128'
        }
        It 'Should fail (to verify the failure message)' {
            '10.1.5.193' | Should -BeInSubnet -Network '10.1.5.0' -Mask '255.255.255.128'
        }
    }
    Context 'Assertions on [ipaddress] objects' {
        $Value = '10.1.5.193' -as [ipaddress]
        $Network = '10.1.5.0' -as [ipaddress]
        $SubnetMask = '255.255.255.0' -as [ipaddress]
        $LargeSubnetMask = '255.0.0.0' -as [ipaddress]
        $SmallSubnetMask = '255.255.255.128' -as [ipaddress]
        
        It '"10.1.5.193" should be in the same subnet as "10.1.5.0" with mask "255.255.255.0"' {
            $Value | Should -BeInSubnet -Network $Network -Mask $SubnetMask
        }
        It '"10.1.5.0" should be in the same subnet as "10.1.5.0" with mask "255.255.255.0"' {
            $Network | Should -BeInSubnet -Network $Network -Mask $SubnetMask
        }
        It '"10.1.5.193" should be in the same subnet as "10.1.5.0" with mask "255.0.0.0"' {
            $Value | Should -BeInSubnet -Network $Network -Mask $LargeSubnetMask
        }
        It '"10.1.5.193" should not be in the same subnet as "10.1.5.0" with mask "255.255.255.128"' {
            $Value | Should -Not -BeInSubnet -Network $Network -Mask $SmallSubnetMask
        }
        It 'Should fail (to verify the failure message)' {
            $Value | Should -BeInSubnet -Network $Network -Mask $SmallSubnetMask
        }
    }
}