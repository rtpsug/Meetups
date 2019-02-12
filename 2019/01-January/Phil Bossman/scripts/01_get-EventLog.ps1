. C:\EvetLogs\Scrub.ps1

Get-Help Get-EventLog -ShowWindow
eventvwr.exe 




Get-EventLog -LogName System -Newest 20 




Get-EventLog -ComputerName Localhost -EntryType Information -newest 20 -LogName System 




Get-EventLog -LogName Application -After (get-date -Format "01-03-2019") -Before (get-date -Format "01-04-2019") -Newest 20 




Get-EventLog -LogName Application -InstanceId 0 -Newest 20




Get-EventLog -LogName Application -InstanceId 0 -Newest 20 |Get-Member



Get-EventLog -List



Get-EventLog -LogName 'Windows PowerShell' -Newest 90



Get-EventLog -LogName Application -EntryType Error | Group-Object -Property EventID -NoElement | sort Count




Get-EventLog -LogName Application -EntryType Error | Group-Object -Property EventID | sort count -OutVariable events
$events
$events[-2].group



Get-EventLog -LogName Application -EntryType Error | 
    Group-Object -Property EventID |
    Select-Object Count,Name,@{Name='Sources';Expression={($_.group | select -ExpandProperty source -Unique) -join ', '}}




 Get-EventLog -LogName Application -EntryType Error |
    Where EventID -eq 1024




 Get-EventLog -LogName Application -EntryType Error |
    Where EventID -eq 1024 | Out-GridView





Get-EventLog -LogName Application -EntryType Error |
    Where EventID -eq 1024 -OutVariable MSiInstallerEvents