. .\DoStuff.ps1

describe 'Get-Thing' {
    it 'should return "I got the thing"' {
        Get-Thing | should -Be 'I got the thing'
    }
}