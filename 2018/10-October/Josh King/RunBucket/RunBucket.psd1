@{
    RootModule = 'RunBucket.psm1'
    ModuleVersion = '0.0.1'
    GUID = '0fb84291-3a12-4a68-9359-aa22a1af4cef'
    Author = 'Joshua (Windos) King'
    CompanyName = 'king.geek.nz'
    Copyright = '(c) 2018 Joshua (Windos) King. All rights reserved.'
    Description = "Module for A/B testing, also known as Bucket or Split-Run testing."
    PowerShellVersion = '5.1'
    RequiredModules = @('PoshRSJob', 'UniversalDashboard')
    FunctionsToExport = 'Start-RunBucket',
                        'Start-ConsoleRunBucket'
    CmdletsToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('Testing', 'Utility')
            LicenseUri = 'https://github.com/Windos/powershell-depot/blob/master/LICENSE.md'
            ProjectUri = 'https://github.com/Windos/powershell-depot/tree/master/Modules/RunBucket'
            IconUri = 'https://raw.githubusercontent.com/Windos/powershell-depot/81c9ad30/Modules/RunBucket/Media/fire-fighter-294192_640.png'
            ReleaseNotes = '
* Initial release
'
        }
    }
}
