Clear-Host

Describe -Name "Files should exist" {
    
    Context "Pre-requisite files should exist" {
        
        It "json file exists" {
            $json = Get-ChildItem ./Airports.json
            $json | Should -Exist
        }
    }
}
