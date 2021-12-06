cd \temp

function Reset-Cache {
<#
  .SYNOPSIS
  Empties the system cache for more consistent performance
  analysis.

  .DESCRIPTION
  Invokes the EmptyStandbyList.exe utility to empty the standby
  list.
  
  Optionally, it can also clear the working sets of all running
  processes.

  Note: you must run in Admin mode to invoke this

  Note: It invokes sytem garbage collection.

  .PARAMETER ClearWorkingSet
  Boolean flag to signal the clearing of working sets

  .PARAMETER ClearWS
  switch flag to signal the clearing of working sets

  .INPUTS
  None. You cannot pipe objects to Reset-Cache.

  .EXAMPLE
  PS> Reset-Cache

  .EXAMPLE
  PS> Reset-Cache -ClearWorkingSet $True

  .EXAMPLE
  PS> Reset-Cache -ClearWS

#>  
  param ([boolean]$ClearWorkingSet = $false,
         [switch]$ClearWS
        )
  & "C:\Users\New User\downloads\EmptyStandbyList.exe" "standbylist"
  [system.gc]::Collect()
  if ($ClearWorkingSet -or $ClearWS){
    & "C:\Users\New User\downloads\EmptyStandbyList.exe" "workingsets"
  }
}

$files = gci newuser*dirlist.txt   #"dirlist.txt", "dosrough.txt", "audit_test.txt"
$VerbosePreference = "Continue" #"SilentlyContinue"
$file_line_counts = @{}

<#
  Construct a hash table of line counts for the dirlist files.

  Note: I'm buffering the I/O and doing some math to avoid 
        unnecessary I/O. Buffered I/O is one of the tricks 
        I showed in my PS Saturday presentation.
#>
$files | 
  %{$bn = $_.basename
    [int64]$lc = 0
    (gc $_.name -ReadCount 2000).foreach({$lc+=$_.count})
    $file_line_counts[$bn] = $lc
   }

Reset-Cache    # for honest (non-cached) I/O perf data

<#
  HHH # 1
  You should use GC -Tail
  rather than GC | Select -Last
#>
foreach ($f in $files){
  write-host "`nFile: $($f.BaseName)"
  write-host "_______________`nGC -head & -tail ; header and summary lines"
  $first_elapsed = (measure-command {gc $f.Name -Head 5}).TotalMilliseconds
  write-verbose "first elapsed: $first_elapsed ms"
  Reset-Cache
  $last_elapsed = (measure-command {gc $f.Name -Tail 5}).TotalMilliseconds
  write-verbose "last elapsed: $last_elapsed ms"
  $elapsed_ms = $first_elapsed + $last_elapsed

  write-host "$elapsed_ms ms", "`tline count: $($file_line_counts[$f.basename])"
  
  Reset-Cache
  write-host "_______________`nGC | select; header and summary lines"
  $first_elapsed = (measure-command {gc $f.Name | select -First 5}).TotalMilliseconds
  write-verbose "first elapsed: $first_elapsed ms"
  Reset-Cache
  $last_elapsed = (measure-command {gc $f.Name | select -Last 5}).TotalMilliseconds
  write-verbose "last elapsed: $last_elapsed ms"
  $elapsed_ms = $first_elapsed + $last_elapsed

  write-host "$elapsed_ms ms", "`tline count: $($file_line_counts[$f.basename])"

}
<#
    File: newuser-pc_program files (x86)_dirlist
    _______________
    GC -head & -tail ; header and summary lines
    VERBOSE: first elapsed: 108.4584 ms
    VERBOSE: last elapsed: 111.5571 ms
    220.0155 ms     line count: 386535
    _______________
    GC | select; header and summary lines
    VERBOSE: first elapsed: 408.5384 ms
    VERBOSE: last elapsed: 13893.9231 ms
    14302.4615 ms   line count: 386535

    File: newuser-pc_program files_dirlist
    _______________
    GC -head & -tail ; header and summary lines
    VERBOSE: first elapsed: 151.5455 ms
    VERBOSE: last elapsed: 109.6837 ms
    261.2292 ms     line count: 296238
    _______________
    GC | select; header and summary lines
    VERBOSE: first elapsed: 1.7992 ms
    VERBOSE: last elapsed: 10485.1802 ms
    10486.9794 ms   line count: 296238

    File: newuser-pc_programdata_dirlist
    _______________
    GC -head & -tail ; header and summary lines
    VERBOSE: first elapsed: 102.3869 ms
    VERBOSE: last elapsed: 23.8539 ms
    126.2408 ms     line count: 221303
    _______________
    GC | select; header and summary lines
    VERBOSE: first elapsed: 2.6237 ms
    VERBOSE: last elapsed: 7979.2541 ms
    7981.8778 ms    line count: 221303

    File: newuser-pc_temp_dirlist
    _______________
    GC -head & -tail ; header and summary lines
    VERBOSE: first elapsed: 60.8345 ms
    VERBOSE: last elapsed: 1.7838 ms
    62.6183 ms      line count: 762
    _______________
    GC | select; header and summary lines
    VERBOSE: first elapsed: 2.8687 ms
    VERBOSE: last elapsed: 29.2572 ms
    32.1259 ms      line count: 762

    File: newuser-pc_users_dirlist
    _______________
    GC -head & -tail ; header and summary lines
    VERBOSE: first elapsed: 83.4878 ms
    VERBOSE: last elapsed: 18.9093 ms
    102.3971 ms     line count: 1645920
    _______________
    GC | select; header and summary lines
    VERBOSE: first elapsed: 2.8197 ms
    VERBOSE: last elapsed: 57717.6524 ms
    57720.4721 ms   line count: 1645920
#>

<#
  HHH # 2
  PS file filtering performance can't overcome I/O bottlenecks.

  Note: Remember the GC -Readcount 2000 tip from my PS Saturday
        presentation.
#>
write-host "_______________`nPS file filtering (first and last lines)"
Reset-Cache
foreach ($f in $files){
    write-host "`nElapsed:", (measure-command{
      $lines = gc $f.Name | ?{$_ -match "^ Directory of|File\(s\)"}
    }).TotalSeconds, "sec"
    write-host "Line count:", $lines.Count
    $lines[0]
    $lines[-1]
}
<#
    PS file filtering (first and last lines)

    Elapsed: 47.0703902 sec
    Line count: 64887
     Directory of c:\program files (x86)
               159429 File(s)    33581550914 bytes

    Elapsed: 55.6405156 sec
    Line count: 47783
     Directory of c:\program files
               128996 File(s)    17024563998 bytes

    Elapsed: 46.1201516 sec
    Line count: 17595
     Directory of c:\programdata
               159719 File(s)    17228569380 bytes

    Elapsed: 0.2181337 sec
    Line count: 61
     Directory of c:\temp
                 547 File(s)      845520443 bytes

    Elapsed: 457.2779198 sec
    Line count: 242447
     Directory of c:\users
               797364 File(s)   131581655553 bytes
#>

<#
  HHH # 3
  FindStr can be your filtering friend/ally.  It automatically
  does buffered I/O.

  Note: multiple /c:"" parameters are combined in a boolean OR
        fashion

#>
write-host "_______________`nFindStr file filtering to PS var"
Reset-Cache
foreach ($f in $files){
    write-host "`nElapsed:", (measure-command{
      $lines = iex ('cmd /c findstr /r /c:"^ Directory of" /c:"^ .*File(s)" ' + "`"$f.name`"")
    }).TotalSeconds, "sec"
    write-host "Line count:", $lines.Count
    $lines[0]
    $lines[-1]
}
<#
    FindStr file filtering to PS var
    
    Elapsed: 10.3328475 sec
    Line count: 64887
     Directory of c:\program files (x86)
               159429 File(s)    33581550914 bytes
    
    Elapsed: 4.4366992 sec
    Line count: 47783
     Directory of c:\program files
               128996 File(s)    17024563998 bytes
    
    Elapsed: 3.8200538 sec
    Line count: 17595
     Directory of c:\programdata
               159719 File(s)    17228569380 bytes
    
    Elapsed: 0.238776 sec
    Line count: 61
     Directory of c:\temp
                 547 File(s)      845520443 bytes
    
    Elapsed: 19.3983813 sec
    Line count: 242447
     Directory of c:\users
               797364 File(s)   131581655553 bytes
#>

<#
  HHH # 4
  limit the lines you need to filter
  (rough filter or, in this case, range filter)

  The PS filtering sure seems slow. (blame the I/O)
  Let's limit the number of lines that need to be filtered.

  Note: we are only going after the summary lines in this example

  Note: These times are on the ms scale, versus the sec scale in
        the prior example.
#>
write-host "_______________`nPS improved file filtering (summary lines)"
Reset-Cache
foreach ($f in $files){
    write-host "`n$($f.BaseName)"
    write-host "Elapsed:", (measure-command{
      $lines = gc $f.Name -Tail 5 | ?{$_ -match "File\(s\)"}
    }).TotalMilliseconds, "ms"
    write-host "Line count:", $lines.count
    write-host "Last filtered line:", $lines[-1]
}
<#
PS improved file filtering (summary lines)

newuser-pc_program files (x86)_dirlist
Elapsed: 181.7523 ms
Line count: 2
Last filtered line:            159429 File(s)    33581550914 bytes

newuser-pc_program files_dirlist
Elapsed: 144.7241 ms
Line count: 2
Last filtered line:            128996 File(s)    17024563998 bytes

newuser-pc_programdata_dirlist
Elapsed: 108.0758 ms
Line count: 2
Last filtered line:            159719 File(s)    17228569380 bytes

newuser-pc_temp_dirlist
Elapsed: 56.0111 ms
Line count: 2
Last filtered line:              547 File(s)      845520443 bytes

newuser-pc_users_dirlist
Elapsed: 120.5678 ms
Line count: 2
Last filtered line:            797364 File(s)   131581655553 bytes

#>

<#
  HHH # 5 - use the Where method, if possible

  Limiting the number of lines that need to be filtered sure helped.
  Let's do our filtering with the Where() method.

  Note: we are only going after the summary lines in this example
#>
write-host "_______________`nPS smart file filtering (summary line)"
Reset-Cache
foreach ($f in $files){
    write-host "`n$($f.BaseName)"
    write-host "Elapsed:", (measure-command{
      $lines = (gc $f.Name -Tail 5).Where({$_ -match "File\(s\)"},'last',1)
    }).TotalMilliseconds, "ms"
    write-host "Line count:", $lines.count
    write-host "Last filtered line:", $lines[-1]
}
<#
PS smart file filtering (summary line)

newuser-pc_program files (x86)_dirlist
Elapsed: 139.1925 ms
Line count: 1
Last filtered line:            159429 File(s)    33581550914 bytes

newuser-pc_program files_dirlist
Elapsed: 125.6846 ms
Line count: 1
Last filtered line:            128996 File(s)    17024563998 bytes

newuser-pc_programdata_dirlist
Elapsed: 107.206 ms
Line count: 1
Last filtered line:            159719 File(s)    17228569380 bytes

newuser-pc_temp_dirlist
Elapsed: 65.0153 ms
Line count: 1
Last filtered line:              547 File(s)      845520443 bytes

newuser-pc_users_dirlist
Elapsed: 76.2358 ms
Line count: 1
Last filtered line:            797364 File(s)   131581655553 bytes
#>

<#
  HHH # 6
  When using piping and redirection in your system
  command strings, be sure to prevent Powershell from
  trying to participate.

  While FindStr is quite efficient, we should prevent
  Powershell from participating in the filtering process.
  In the GOOD filtering example, the pipe character is escaped.
  In the BAD filtering example, the pipe character is *not* escaped.

  Task Manager will show cmd and findstr (QGREP) activity when the
  GOOD example is running.

  Compare these GOOD times against the Optimized_Root_Tree_Solution
  performance figures.

  Task Manager will show cmd and lots of Powershell activity when 
  the BAD example is running.
#>
$root_dirs = "temp", "programdata", "program files", "program files (x86)", "users"
write-host "_______________`nDir | FindStr GOOD filtering to PS variable"
Reset-Cache
foreach ($rd in $root_dirs){
  write-host "`nroot dir:", "c:\$rd"
  write-host "Elapsed:", (Measure-Command{
    $lines = iex ('cmd /c dir /a-l /-c /s "c:\' + $rd + '" `| findstr /r /c:"^ Directory of" /c:"^  .*File(s)" ')
  }).TotalSeconds, "sec"
  write-host "Line count:", $lines.count
  write-host "First filtered line:", $lines[0]
  write-host "Last filtered line:", $lines[-1]
}
<#
Dir | FindStr GOOD filtering to PS variable

root dir: c:\temp
Elapsed: 3.8780724 sec
Line count: 61
First filtered line:  Directory of c:\temp
Last filtered line:              550 File(s)      911566745 bytes

root dir: c:\programdata
Elapsed: 53.0983745 sec
Line count: 17595
First filtered line:  Directory of c:\programdata
Last filtered line:            159721 File(s)    17228576216 bytes

root dir: c:\program files
Elapsed: 114.6959029 sec
Line count: 47785
First filtered line:  Directory of c:\program files
Last filtered line:            129047 File(s)    17024643541 bytes

root dir: c:\program files (x86)
Elapsed: 139.4625269 sec
Line count: 64887
First filtered line:  Directory of c:\program files (x86)
Last filtered line:            159429 File(s)    33581550914 bytes

root dir: c:\users
Elapsed: 735.9604563 sec
Line count: 242445
First filtered line:  Directory of c:\users
Last filtered line:            798159 File(s)   131590137101 bytes
#>

write-host "_______________`nDir | FindStr BAD filtering to PS variable"
Reset-Cache
foreach ($rd in $root_dirs){
  write-host "`nroot dir:", "c:\$rd"
  write-host "Elapsed:", (Measure-Command{
    $lines = iex ('cmd /c dir /a-l /-c /s "c:\' + $rd + '" | findstr /r /c:"^ Directory of" /c:"^  .*File(s)" ')
  }).TotalSeconds, "sec"
  write-host "Line count:", $lines.count
  write-host "First filtered line:", $lines[0]
  write-host "Last filtered line:", $lines[-1]
}
<#
Dir | FindStr BAD filtering to PS variable

root dir: c:\temp
Elapsed: 1.904999 sec
Line count: 61
First filtered line:  Directory of c:\temp
Last filtered line:              550 File(s)      911566745 bytes

root dir: c:\programdata
Elapsed: 127.2134406 sec
Line count: 17595
First filtered line:  Directory of c:\programdata
Last filtered line:            159721 File(s)    17228577664 bytes

root dir: c:\program files
Elapsed: 216.183992 sec
Line count: 47785
First filtered line:  Directory of c:\program files
Last filtered line:            129054 File(s)    17024653370 bytes

root dir: c:\program files (x86)
Elapsed: 207.8595476 sec
Line count: 64887
First filtered line:  Directory of c:\program files (x86)
Last filtered line:            159429 File(s)    33581550914 bytes

root dir: c:\users
Elapsed: 1055.8198201 sec
Line count: 242447
First filtered line:  Directory of c:\users
Last filtered line:            798250 File(s)   131588816853 bytes
#>

<#
  HHH # 7 - save intermediate results to a file

  Here, we cut out PS completely from the filtering process
  by redirecting the output to a file.

  Note: both the pipe and redirect characters are escaped
#>
write-host "_______________`nDir | FindStr filtering to file"
Reset-Cache
foreach ($rd in $root_dirs){
  write-host "`nroot dir:", "c:\$rd"
  write-host 'IEX elapsed:', (Measure-Command{
    iex ('cmd /c dir /a-l /-c /s "c:\' + $rd + '" `| findstr /r /c:"^ Directory of" /c:"File\(s\)" `> "c:\temp\newuser-pc_' + $rd + '_filtered.txt" ')
  }).TotalSeconds, "sec"
  $line_count = (gc "c:\temp\newuser-pc_$($rd)_filtered.txt").count
  $first_elapsed = (measure-command {$first_line = gc "c:\temp\newuser-pc_$($rd)_filtered.txt" -Head 1}).TotalMilliseconds
  $last_elapsed = (measure-command {$last_line = gc "c:\temp\newuser-pc_$($rd)_filtered.txt" -Tail 1}).TotalMilliseconds
  write-host "Line count:", $line_count
  write-host "first_line_elapsed: $first_elapsed ms"
  write-host "last_line_elapsed: $last_elapsed ms"
  $first_line
  $last_line
}
<#
Dir | FindStr filtering to file

root dir: c:\temp
IEX elapsed: 1.7102852 sec
Line count: 61
first_line_elapsed: 2.3195 ms
last_line_elapsed: 34.6955 ms
 Directory of c:\temp
             550 File(s)      911563738 bytes

root dir: c:\programdata
IEX elapsed: 41.1128566 sec
Line count: 17595
first_line_elapsed: 27.9022 ms
last_line_elapsed: 1.5449 ms
 Directory of c:\programdata
           159722 File(s)    17228638845 bytes

root dir: c:\program files
IEX elapsed: 94.2058522 sec
Line count: 47787
first_line_elapsed: 38.2432 ms
last_line_elapsed: 1.1548 ms
 Directory of c:\program files
           129062 File(s)    17024662044 bytes

root dir: c:\program files (x86)
IEX elapsed: 126.3344125 sec
Line count: 64887
first_line_elapsed: 1.2579 ms
last_line_elapsed: 4.1738 ms
 Directory of c:\program files (x86)
           159429 File(s)    33581550914 bytes

root dir: c:\users
IEX elapsed: 621.3165027 sec
Line count: 242447
first_line_elapsed: 1.585 ms
last_line_elapsed: 1.2603 ms
 Directory of c:\users
           798251 File(s)   131588877730 bytes
#>

#===================================
#===================================
#===================================

break

<#
What follows is code to create the dirlist, fileslist, and widelist
files.
#>
foreach ($rd in $root_dirs){
  write-verbose "`nroot dir:", "c:\$rd"
  iex ('cmd /c dir /a-l /-c /s "c:\' + $rd + '" `> "c:\temp\newuser-pc_' + $rd + '_dirlist.txt" ')
  iex ('cmd /c dir /a-d-l /-c /s "c:\' + $rd + '" `> "c:\temp\newuser-pc_' + $rd + '_fileslist.txt" ')
  iex ('cmd /c dir /w /a-d-l /-c /s "c:\' + $rd + '" `> "c:\temp\newuser-pc_' + $rd + '_widelist.txt" ')
}
