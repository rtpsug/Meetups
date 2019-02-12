## References
## https://blogs.technet.microsoft.com/ashleymcglone/2013/08/28/powershell-get-winevent-xml-madness-getting-details-from-event-logs/
###


# List all event providers            
Get-WinEvent -ListProvider * | Format-Table          
            
# List all policy-related event providers.            
Get-WinEvent -ListProvider *policy* | Format-Table            
            
# List the logs on the machine where the name is like 'policy'            
Get-WinEvent -ListLog *policy*            
            
# List all possible event IDs and descriptions for the provider            
(Get-WinEvent -ListProvider Microsoft-Windows-GroupPolicy).Events |            
    Format-Table id, description -AutoSize            
            
# List all of the event log entries for the provider            
Get-WinEvent -LogName Microsoft-Windows-GroupPolicy/Operational            
            
# Each event in each provider has its own message data schema.            
# Use this line to find the schema of each event ID.            
# For a specific event            
(Get-WinEvent -ListProvider Microsoft-Windows-GroupPolicy).Events 
Where-Object {$_.Id -eq 5314}
            
# For a keyword in the event data            
(Get-WinEvent -ListProvider Microsoft-Windows-GroupPolicy).Events |            
    Where-Object {$_.Template -like "*reason*"} |
    Select Id, Description | ft -AutoSize        
