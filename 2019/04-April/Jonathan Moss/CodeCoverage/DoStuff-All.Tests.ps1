## Dot source the script
. "$PSScriptRoot\DoStuff.ps1"

describe 'Get-Thing' {
    it 'should return "I got the thing"' {
        Get-Thing | should be 'I got the thing'
    }
}

describe 'Do-Thing' {
    it 'should return "I did the thing"' {
        Do-Thing ## Notice no should assertion here. Whoops!
    }
}

describe 'Set-Thing' {
    it 'should return "I set the thing"' {
        Set-Thing ## Notice no should assertion here. Whoops!
    }
}