
#$oldPSPath = $env:PSModulePath
#$env:PSModulePath += ';C:\Users\brandon\OneDrive\Documents\GitHub\presentations\RTPSUG_Infrastructure_Testing\scripts'

#Import-Module WindowsCompatibility
#Import-WinModule Microsoft.PowerShell.Management

WatchmenTest 'MyApp.OVF' {
    notifies {
        logfile '/Users/bolin/temp/watchmen.log'
        # slack @{
        #     Token = '<SLACK-TOKEN>'
        #     Channel = '#Watchmen'
        #     AuthorName = $env:COMPUTERNAME
        #     PreText = 'Everything is on :fire:'
        #     IconEmoji = ':fire:'
        # }
    }
}

#$env:PSModulePath = $oldPSPath