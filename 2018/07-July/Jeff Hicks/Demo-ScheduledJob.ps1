#requires -version 3.0

#this will only run under PowerShell running on Windows

return "This is a walkthrough demo - not a script."

#demo from a domain member
# enter-pssession -VMName win10 -Credential company\artd

#This must be run in an elevated session
#Don't confuse this with ScheduledTasks module 

# These commands are in the PSScheduledJob module
get-command -module PSScheduledJob

# Define when to run the job
help new-jobTrigger

$trigger = New-JobTrigger -Daily -At 8:00AM

# Let's see what we created
$trigger

# Define a name for the scheduled job to save typing
$name = "Domain Controller Service Check"

# Define a scriptblock. You would normally create a multiline scriptblock.
# I have a one liner for the sake of my demo.
#I want a formatted result I can look at.
$action = {
    $services = 'DNS', 'ADWS', 'NTDS', 'KDC'
    Get-Service $services -ComputerName dom1|
        Sort-object Machinename |  Format-Table -GroupBy Machinename -property Name, Displayname, Status
}

#test the scriptblock
invoke-command $action

#add some options
$opt = New-ScheduledJobOption -RequireNetwork

# Register the job
help Register-ScheduledJob

$paramHash = @{
    Name               = $name
    ScriptBlock        = $action
    Trigger            = $trigger
    ScheduledJobOption = $opt
}

Register-ScheduledJob @paramHash

# We can see the scheduled job is now registered
Get-ScheduledJob -Name $name

# Define a variable for the job path so we don't have to retype
$jobpath = "$env:LocalAppData\Microsoft\Windows\PowerShell\ScheduledJobs"
dir $jobpath -recurse

# show the job in Task Scheduler Microsoft\Windows\PowerShell\SchedJobs
Taskschd.msc
#find the task with Task Scheduler cmdlets
Get-ScheduledTask -TaskName $name

# this is a rich object
Get-ScheduledJob -Name $name | get-member
Get-ScheduledJob -Name $name | Select-object *

# We can also see when it will execute
get-jobtrigger $name

#or this way 
Get-ScheduledJob $name | Get-JobTrigger

# let's look at options
Get-ScheduledJobOption -Name $name

# or modify options. Works best in a pipeline
help Set-ScheduledJobOption

Get-ScheduledJobOption -Name $name | 
    Set-ScheduledJobOption -RunElevated -passthru | Select Run*

# we can modify the trigger
help set-jobtrigger

Get-JobTrigger $Name

Get-JobTrigger $Name | 
    Set-JobTrigger -at 12:00PM -PassThru 

#manually kick off in the Task Scheduler
#or use Task Scheduler commands
Get-ScheduledTask $name | Start-ScheduledTask 

# get the job using the standard job cmdlets after it has run
# this may have failed depending on what you are trying to do
Get-Job
Get-ScheduledJob

# You can also start a scheduled job manually. Notice the new parameter
Start-Job -DefinitionName $Name

# Now what do we see in the job queue?
Get-Job

# there are some new properties
Get-Job -Name $name -Newest 1 | Select *

# get job results
Receive-job $name -keep

#results written to disk
dir $jobpath -recurse

#disabling the job
Help Disabled-ScheduledJob
Disable-ScheduledJob $name -WhatIf
Disable-ScheduledJob $name -PassThru

#if I wanted to re-enable
Enable-ScheduledJob $name -WhatIf

#And finally we'll remove the scheduled job
help Unregister-ScheduledJob
Unregister-ScheduledJob -Name $name

Get-ScheduledJob

#also clears job queue
Get-job

#UNREGISTERING ALSO DELETES HISTORY AND OUTPUT
dir $jobpath -recurse

#accessing network resources requires credential
get-content C:\scripts\volreport.ps1

$params = @{
    Name                 = "VolumeReport"
    Trigger              = (New-JobTrigger -At 6:00 -Weekly -DaysOfWeek Monday, Wednesday, Friday)
    MaxResultcount       = 5
    ScheduledJobOption   = (New-ScheduledJobOption -RunElevated -RequireNetwork)
    Filepath             = "C:\scripts\volreport.ps1"
    Credential           = (Get-Credential company\artd)
    Argumentlist         = @(@("dom1", "srv2", "srv1"), "c:\work\volume.csv")
    InitializationScript = { Import-module Storage}
}

register-scheduledjob @params

get-scheduledtask $params.name | Start-ScheduledTask
# start-job -DefinitionName $params.name | wait-job

#wait a minute
Get-Job
#my job doesn't really write a result.
import-csv C:\work\volume.csv

Unregister-ScheduledJob $params.Name
del C:\work\volume.csv

#again, these are the commands you'll use
get-command -module PSScheduledJob

#read help
help about_scheduled 
#or read the raw text file
dir C:\windows\system32\WindowsPowerShell\v1.0\Modules\PSScheduledJob\en-US
psedit C:\windows\system32\WindowsPowerShell\v1.0\Modules\PSScheduledJob\en-US\about_Scheduled_Jobs_Basics.help.txt

cls

