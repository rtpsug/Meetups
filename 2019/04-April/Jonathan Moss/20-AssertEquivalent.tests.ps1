## Show off Assert module from @nohwnd
## Compare 2 objects and exclude a property

Clear-Host

$Jonathan = [PSCustomObject]@{
    Age       = 31
    Languages = 'English'
    Hobbies   = 'family', 'church'
}

$Mike = [PSCustomObject]@{
    Age       = 49
    Languages = 'English'
}

$options = Get-EquivalencyOption -ExcludePath "Hobbies"

Assert-Equivalent -Actual $Jonathan -Expected $Mike -Options $options