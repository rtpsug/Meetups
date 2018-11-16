function Get-LdapUser($filter) {
    $objDomain = ([adsi]"LDAP://RootDSE").rootDomainNamingContext
    #$objDomain = New-Object system.directoryservices.directoryentry("LDAP://ou=people,dc=wolftech,dc=ad,dc=ncsu,dc=edu")
    $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
    $objSearcher.SearchRoot = "LDAP://$objDomain"
    $objSearcher.Filter = $filter
    #$objSearcher.PropertiesToLoad.Add("department")
    #$objSearcher.findone()
    $objSearcher.FindAll()
}
