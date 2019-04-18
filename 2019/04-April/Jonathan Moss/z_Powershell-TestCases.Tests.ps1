## From Powershell Github
## https://github.com/PowerShell/PowerShell/blob/master/docs/testing-guidelines/WritingPesterTests.md 

$testCases = @(
    @{ a = 0; b = 1; ExpectedResult = 1 }
    @{ a = 1; b = 0; ExpectedResult = 1 }
    @{ a = 1; b = 1; ExpectedResult = 0 }
    @{ a = 0; b = 0; ExpectedResult = 0 }
    )

Describe "A test" {
    It "<a> -xor <b> should be <expectedresult>" -TestCases $testCases {
        param ($a, $b, $ExpectedResult)
        $a -xor $b | Should -Be $ExpectedResult
    }
}