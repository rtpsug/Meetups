
# Doc, Is This Operation Necessary?

$Control = {
    $PSVersion = $PSVersionTable.PSVersion

    <#
        Major  Minor  Build  Revision
        -----  -----  -----  --------
        5      1      16299  251
    #>

    $TestVersion = '5.1.15000'

    $SplitVersion = $TestVersion.Split('.')

    if ($PSVersion.Major -ge $SplitVersion[0]) {
        if ($PSVersion.Minor -ge $SplitVersion[1]) {
            if ($PSVersion.Build -ge $SplitVersion[2]) {
                $true
            } else {
                $false
            }
        } else {
            $false
        }
    } else {
        $false
    }
}

$Variation = {
    $PSVersion = $PSVersionTable.PSVersion

    [Version] $TestVersion = '5.1.15000'

    $PSVersion -ge $TestVersion
}

Start-RunBucket -Control $Control -Variation $Variation -Title 'Unnecessary Operations'
