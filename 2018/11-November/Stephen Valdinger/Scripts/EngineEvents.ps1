#Exiting event
Import-Module BurntToast

Register-EngineEvent -SourceIdentifier Powershell.Exiting -Action {

    $Header = New-BTHeader -Id 1 -Title "Powershell Exit"

    New-BurntToastNotification -Text "Whatever you were doing is done, and Powershell exited" -Header $Header -Silent

}

#Custom Events
Register-EngineEvent -SourceIdentifier Test -Action { 
    
    New-BurntToastNotification -Header (New-BTHeader -Id 1 -Title "Engine Event Test") -Text "$($event.MessageData)" 

}

#Let's see what happens, shall we?
New-Event -SourceIdentifier Test -Sender PowershellTesting -MessageData "Blah"