<#
  Solving the Root Trees size problem - optimized configuration
  Since we know the root dir name, we only need the last file
  line.

  Dir /w /a-d-l /-c /s | Findstr c:"File(s)"
  * ignore empty directories
  * wide format to minimize lines
  * numeric-ready counts and sizes

  .Where({$true},'last',5)
  * keep the last 5 lines returned
  * minimizes the memory footprint of Powershell

  .Where({$_ -clike "*File(s)*"},'last',1)
  * keep the last "File(s)" line
#>
<#
The following instantiation of $root_dirs mirrors the one used
in my lightning talk examples
#>
$root_dirs = "temp", "programdata", "program files", "program files (x86)", "users"

<#
If you want to get a list of all the root directory trees on
the C: drive, then use the following statement.
$root_dirs = iex ("cmd /c dir /b /ad-l c:\")
#>

Reset-Cache

<#
  Performance test
#>
foreach ($rd in $root_dirs){
  write-host "`nroot dir:", "c:\$rd"
  write-host "Elapsed:", (Measure-Command{
    $lines = (iex ('cmd /c dir /w /a-d-l /-c /s "c:\' + $rd + '" `| findstr /c:"^ .*File(s)" ')).where({$true},'last',5).where({$_ -clike "*File(s)*"},'last',1)
    }).TotalSeconds, "sec"
  write-host "Line count:", $lines.count
  write-host "Filtered line:", $lines
}
<#
Output from the above performance test code:

root dir: c:\temp
Elapsed: 2.0901956 sec
Line count: 1
Filtered line:              550 File(s)      911567200 bytes

root dir: c:\programdata
Elapsed: 43.8017684 sec
Line count: 1
Filtered line:            159728 File(s)    17227658250 bytes

root dir: c:\program files
Elapsed: 70.1723161 sec
Line count: 1
Filtered line:            129212 File(s)    17024909934 bytes

root dir: c:\program files (x86)
Elapsed: 97.314895 sec
Line count: 1
Filtered line:            159429 File(s)    33581550914 bytes

root dir: c:\users
Elapsed: 469.92451415 sec
Line count: 1
Filtered line:            797945 File(s)   131603479469 bytes
#>

<#
# A production version
foreach ($rd in $root_dirs){
  $LastFilesLine = (iex ('cmd /c dir /w /a-d-l /-c /s "c:\' + $rd + '" `| findstr /r /c:"^ .*File(s)" ')).where({$true},'last',5).where({$_ -clike "*File(s)*"},'last',1)
  $m = [regex]::Match($LastFilesLine, "(\d+) File\(s\) +(\d+)")
  [pscustomobject]@{
    rootdir = $rd
    Filecount = [int64]$m.groups[1].value
    treesize = [int64]$m.groups[2].value
  }
}

#>