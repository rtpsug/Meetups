# Speaker Notes
These are notes and extra material/code for my
2021-12-01 lightning talk at RTPSUG.

## Introduction
Recent question about sizes of root directory trees was
similar to Phil Bossman problem I used as my PS Saturday
example.

### Size of my root trees (1 small, 3 large, 1 very large)
```
tree: c:\Temp\
535 Files, 29 Folders
531 MB (557,579,502 bytes)

tree: c:\ProgramData\
156,236 Files, 8,714 Folders
15.1 GB (16,292,726,301 bytes)

tree: c:\Program Files\
128,468 Files, 23,853 Folders
15.5 GB (16,725,507,932 bytes)

tree: c:\Program Files (x86)\
159,394 Files, 32,442 Folders
30.9 GB (33,207,574,993 bytes)

tree: c:\Users\
628,549 Files, 111,348 Folders
105 GB (113,035,576,985 bytes)
```

### Size of files with different Dir output and filtered output
```
 Volume in drive C has no label.
 Volume Serial Number is 5666-CBFB

 Directory of C:\Temp

12/01/2021  07:12 AM        19,943,834 newuser-pc_program files (x86)_dirlist.txt
12/01/2021  07:12 AM        14,842,241 newuser-pc_program files (x86)_fileslist.txt
12/01/2021  05:34 AM         5,429,765 newuser-pc_program files (x86)_filtered.txt
12/01/2021  07:13 AM        11,239,003 newuser-pc_program files (x86)_widelist.txt
12/01/2021  07:11 AM        14,356,247 newuser-pc_program files_dirlist.txt
12/01/2021  07:12 AM        10,585,163 newuser-pc_program files_fileslist.txt
12/01/2021  05:51 AM         3,517,488 newuser-pc_program files_filtered.txt
12/01/2021  07:12 AM         7,705,332 newuser-pc_program files_widelist.txt
12/01/2021  07:11 AM        15,952,706 newuser-pc_programdata_dirlist.txt
12/01/2021  07:11 AM        14,553,974 newuser-pc_programdata_fileslist.txt
12/01/2021  05:53 AM         1,525,632 newuser-pc_programdata_filtered.txt
12/01/2021  07:11 AM         9,380,892 newuser-pc_programdata_widelist.txt
12/01/2021  07:11 AM            36,542 newuser-pc_temp_dirlist.txt
12/01/2021  07:11 AM            31,911 newuser-pc_temp_fileslist.txt
12/01/2021  05:52 AM             3,007 newuser-pc_temp_filtered.txt
12/01/2021  07:11 AM            14,617 newuser-pc_temp_widelist.txt
12/01/2021  07:14 AM        85,462,958 newuser-pc_users_dirlist.txt
12/01/2021  07:15 AM        66,032,272 newuser-pc_users_fileslist.txt
12/01/2021  05:44 AM        18,948,465 newuser-pc_users_filtered.txt
12/01/2021  07:16 AM        46,607,789 newuser-pc_users_widelist.txt
              20 File(s)    346,169,838 bytes
               0 Dir(s)  56,920,186,880 bytes free
```

## Hutchinson Helpful Hints (HHH)
__Note:__ some of the hints are here and some are in the
comments in the PS code.

Hutchinson Helpful Hints for PS  
* make sure any pipe or redirect characters are escaped
* look at Task Manager while testing 
(you should see cmd & findstr, 
 __not__ cmd and LOTS of Powershell CPU use)
* minimize the amount of data to be filtered
* minimize piping, if possible
* Dir /a-l avoids junction and symlink objects
* Since folder names can contain an underscore, consider
a multi-character delimiter, when saving Dir output
to a file.
* Remember the -ReadCount 2000 and foreach (){} tip from 
my PS Saturday presentation
* multiple FindStr /c:"" parameters are an implied OR for the
comparisons.  This is similar to a regex "x|y|z" pattern.
* object properties and methods are generally faster than putting
the object into the pipeline

* The second .Where parameter   
| Name | Description |  
| ------ | ------------- |  
| Default | Return all matches. |  
| First | Stop processing after the first match. |  
| Last | Return the last matching element. |  
| SkipUntil | Skip until the condition is true, then return the rest. |  
| Split | Return an array of two elements, first index is matched elements, second index is the remaining elements. |  
| Until | Return elements until the condition is true then skip the rest. |  
https://mcpmag.com/articles/2015/12/02/where-method-in-powershell.aspx  
      
* Show doubled up .Where() methods
  .where({$_ -clike " *"}).where({$_ -clike " Dir*"})
	* This didn't improve performance, since it didn't sufficiently
	  reduce the number of items for the second Where() method to 
	  compare.

  .where({$true},'last', 5).where({$_ -clike "*File(s)*"}, 'last', 1)
    * This __did__ improve performance.
	* However, this still doesn't beat array slicing for data reduction
	* It was good enough to use in the 
	  Optimized_Root_Tree_Solution.ps1
	  to filter the result of the IEX command

===============================
===============================

## Collection-Filtering tests
Below are some collection/array filtering tests to help
you understand the relative performance of different 
methods.
### Setup
```
$lines = gc newuser-pc_programdata_dirlist.txt

PS C:\temp> $lines.count
242447
```
### Getting a count of lines
This one is an excellent example of why we should use
collection methods, rather than pushing things through
the pipeline.
```
PS C:\temp> measure-command{($lines | measure).count}
TotalSeconds      : 17.3814019
TotalMilliseconds : 17381.4019

PS C:\temp> measure-command{$lines.count}
TotalSeconds      : 0.0411973
TotalMilliseconds : 41.1973
```
### Getting the count of " Directory of" lines
The first two examples use the pipeline.  The rest of the
examples use the .Where() method.

In one of these later tests, I chained the .Where() methods
to achieve a 'rough filter' of the lines.  But this didn't 
improve the filtering.  The directory comparison already
begins with a space, so the early filter wasn't doing enough
to reduce the input data to the second .Where() method.
```
PS C:\temp> measure-command{($lines | ?{$_ -clike " Directory of*"} | measure).count}
TotalSeconds      : 52.7246152
TotalMilliseconds : 52724.6152

PS C:\temp> measure-command{($lines | ?{$_ -clike " Directory of*"}).count}
TotalSeconds      : 49.9324416
TotalMilliseconds : 49932.4416

PS C:\temp> measure-command{($lines.where({$_ -clike " Dir*"})).count}
TotalSeconds      : 20.0994589
TotalMilliseconds : 20099.4589

PS C:\temp> measure-command{($lines.where({$_ -clike " *"}).where({$_ -clike " Dir*"})).count}
TotalSeconds      : 20.5111475
TotalMilliseconds : 20511.1475
```
### First instance test
The .Where() method has multiple parameters that allow you 
to filter differently.  The default is to filter all input
items.  We can also stop filtering after we find a match.
```
PS C:\temp> measure-command{$lines.where({$_ -clike " Dir*"}, 'first', 1)}
TotalSeconds      : 0.0010321
TotalMilliseconds : 1.0321
```
### Last instance of File(s)
In addition to the first instance, we can find the last 
instance of a matching pattern.  We can combine the pattern
test with a limit of input items to speed the filtering
process.  

In the second test, I use multiple .Where() 
methods.  The first, limits the input to the last 5 items.
If you have an input stream, this would be the place to 
use this approach.

In the third test, I use slicing to limit the items.  As
you can see, slicing is the most efficient method.
```
PS C:\temp> measure-command{$lines.where({$_ -clike "*File(s)*"}, 'last', 1)}
TotalSeconds      : 22.4229356
TotalMilliseconds : 22422.9356

PS C:\temp> measure-command{$lines.where({$true},'last', 5).where({$_ -clike "*File(s)*"}, 'last', 1)}
TotalSeconds      : 9.842214
TotalMilliseconds : 9842.214

PS C:\temp> measure-command{$lines[-5..-1].where({$_ -clike "*File(s)*"}, 'last', 1)}
TotalSeconds      : 0.0010204
TotalMilliseconds : 1.0204
```