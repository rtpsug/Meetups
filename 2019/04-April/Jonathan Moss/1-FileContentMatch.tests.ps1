## file content matches
## https://github.com/pester/Pester/wiki/TestDrive
## TestDrive is a PowerShell PSDrive for file activity limited to the scope of a single Describe or Context block.

Describe "File Content Stuff" {

    It "airports.txt matches" {
            Set-Content -Path TestDrive:\airports.txt -Value 'The best airport is ATL. Change my mind.'
            'Testdrive:\airports.txt' | Should -FileContentMatch 'The best airport is ATL. Change my mind.'
        }

}