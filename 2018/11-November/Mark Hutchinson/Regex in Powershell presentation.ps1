cls
$a = "Now is the time for 300 Spartans to stand against 100000 Persians at Thermopylae in 480BCE"
#Is there a digit(s) and letter(s) sequence in the string?
write-host '"\d+[A-Za-z]+"' "`t" ($a -match "\d+[A-Za-z]+")
write-host '$matches:'
$matches
write-host '$matches[0]: ' "`t"  $matches[0]

break
cls
#Is there a digit(s) sequence in the string?
write-host '"\d+"' "`t" ($a -notmatch "\d+")
write-host '$matches[0]: ' "`t"  $matches[0]

#Note: default -match (= -imatch) operator is case-insensitive
cls
write-host '"STAND"' "`t" ($a -imatch "STAND")
write-host '$matches[0]: ' "`t"  $matches[0]

#That is why you should use -cmatch
cls

$m = ($a -notmatch "\d+")  #I'm repeating this on purpose

write-host '-cmatch "STAND"' "`t" ($a -cmatch "STAND")
# Note that $matches is not reset/cleared if there is no match
write-host '$matches[0]: ' "`t"  $matches[0]
$matches -eq $null

#$matches is treated similarly for -notmatch/-cnotmatch operations
cls

$m = ($a -notmatch "\d+")  #I'm repeating this on purpose
write-host '-cnotmatch "Now"' "`t" ($a -cnotmatch "Now")
write-host '$matches[0]: ' "`t"  $matches[0]
# Note that $matches is *NOT* reset/cleared if there is notmatch is true

$m = ($a -notmatch "\d+")  #I'm repeating this on purpose
write-host '-cnotmatch "now"' "`t" ($a -cnotmatch "now")
write-host '$matches[0]: ' "`t"  $matches[0]
# Note that $matches *IS* reset if there is notmatch is false

break
#It's time correct the tense - move from matching to changing
$a = $a -creplace 'Now is','Now was'
$a
#Note: if there are multiple "Now is" strings, we can change the pattern.
#   The example pattern I gave in the presentation was '^Now is' to ensure
#   the change takes place at the start of the string.
#   Thanks for that question.

break
#Let's create some test questions for our students
$a -replace '\d+ \w+','_#_ _____'

#What if new research upped the number of Persians -- case matters
$a -replace '\d+ persians','150000 Persians'    #ignore case
$a -creplace '\d+ persians','150000 Persians'   #lower case P
$a -creplace '\d+ Persians','150000 Persians'   #upper case P

#___________________
#Only do if time permits - rearranging the text in $a
<#========================
break
#If we use grouping, we can reference the groups in our replace operation
#In this example, we are swapping the two digit-word pairs
$a -replace '^(\D+)(\d+ \w+)(\D+)(\d+ \w+)(.+)','$1$4$3$2$5'

#we can do this more simply - pattern simplicity matters
$a -replace '(\d+ \w+)(\D+)(\d+ \w+)','$3$2$1'
$a -replace '^(\D+\d+\D+) (\d+)','$1 150000'
#>


<#___________________
#Only do if time permits - Excel -> Mapquest example
#========================
break
#Mapquest routing example (copy/paste Excel -> NPP -> Mapquest)
$cells = "Mark`t24 Meadhall Ct`tDurham`tNC`t27713"
write-host "what gets pasted from Excel: `t"  $cells
write-host "after replace: `t"  ($cells -replace '([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t(\d+)', '$2,$3,$4,$5"$1"')

#Note: actual replace operation was multiple lines
#>


break
#****************************
#End of First Demo
#****************************

<#
    We are a step closer to the full power of regex.
    We can parse strings, accessing *ALL* the matches, not just the first.
    For serious endeavors, instantiate a .Net regex object.
    For purposes of introduction, I'll use Select-String.
#>

# What are my digit(s) values?
cls
($a | Select-String "\d+" -AllMatches).Matches

# What are my digits followed by letters values?
cls
($a | Select-String "\d+[A-Za-z]+" -AllMatches).Matches

# Parsing example with two capturing groups
# What are my digits followed by zero or more letters values?
cls
$m = ($a | Select-String "(\d+)([A-Za-z]*)" -AllMatches).Matches
$m

break

#___________________
#Only do if time permits - exploring the Matches
<#
cls
# Here's the matches object
($a | Select-String "\d+[A-Za-z]*" -AllMatches).Matches
# Just the matches value
($a | Select-String "\d+[A-Za-z]*" -AllMatches).Matches.Value

# We can use \w here, but it matches more than letters
($a | Select-String "\d+\w*" -AllMatches).Matches.Value

# Look at the effect of repeats - understanding {m, n} pattern
# 0 to 2 trailing letters
($a | Select-String "\d+[A-Za-z]{0,2}" -AllMatches).Matches.Value
# 0 to 3 trailing letters
($a | Select-String "\d+[A-Za-z]{0,3}" -AllMatches).Matches.Value
# 0 or more trailing letters - no upper bound
($a | Select-String "\d+[A-Za-z]{0,}" -AllMatches).Matches.Value
# 4 trailing letters
($a | Select-String "\d+[A-Za-z]{4}" -AllMatches).Matches.Value
#>

break

#Now for some If statement examples
cls
if ($a -match "\d+[EDCBA]+") {"thar be dates"}
else {"shivver me timbers"}

# once again, case sensitivity matters
cls
if ($a -cmatch "now") {"it's time"}
else {"wait"}

cls
if ($a -cmatch "Now") {"it's time"}
else {"wait"}

break

#____________________________________
#Now for some Switch statment examples

<#
Valid MRN rules:
    one letter (not I or O) followed by 5 digits
    two letters (not I or O) followed by 4 digits
    D followed by 7 digits
#>
cls
$MRN = "br549"    #too few digits
switch -Regex ($mrn)
{
    '[A-HJ-NP-Z]\d{5}' {"original MRN"; break}
    '[A-HJ-NP-Z]{2}\d{4}' {"old MRN"; break}
    'D\d{7}' {"Epic MRN"; break}
    default {"invalid MRN"}
}

cls
$MRN = "br5499"    #ok
switch -Regex ($mrn)
{
    '[A-HJ-NP-Z]\d{5}' {"original MRN"; break}
    '[A-HJ-NP-Z]{2}\d{4}' {"old MRN"; break}
    'D\d{7}' {"Epic MRN"; break}
    default {"invalid MRN"}
}

cls
$MRN = "br54900"    #too many digits - invalid regex pattern
switch -Regex ($mrn)
{
    '[A-HJ-NP-Z]\d{5}' {"original MRN"; break}
    '[A-HJ-NP-Z]{2}\d{4}' {"classic MRN"; break}
    'D\d{7}' {"Epic MRN"; break}
    default {"invalid MRN"}
}

cls
$MRN = "br54900"    #too many digits - valid regex pattern
switch -Regex ($mrn)
{
    '^[A-HJ-NP-Z]\d{5}$' {"original MRN"; break}
    '^[A-HJ-NP-Z]{2}\d{4}$' {"classic MRN"; break}
    '^D\d{7}$' {"Epic MRN"; break}
    default {"invalid MRN"}
}

#Here's the cmatch analog:
cls
$MRN = "br5499"
switch -Regex -CaseSensitive ($mrn)
{
    '^[A-HJ-NP-Z]\d{5}$' {"original MRN"; break}
    '^[A-HJ-NP-Z]{2}\d{4}$' {"classic MRN"; break}
    '^D\d{7}$' {"Epic MRN"; break}
    default {"invalid MRN"}
}

cls
$MRN = "BR5499"   # case-corrected MRN - should be valid
switch -Regex -CaseSensitive ($mrn)
{
    '^[A-HJ-NP-Z]\d{5}$' {"original MRN"; break}
    '^[A-HJ-NP-Z]{2}\d{4}$' {"classic MRN"; break}
    '^D\d{7}$' {"Epic MRN"; break}
    default {"invalid MRN"}
}

#____________________________________
# Now for a function param example
break
Function IsValidMRN{
  Param
    (
    [parameter(Mandatory=$true)]
    [ValidatePattern("(^[A-HJ-NP-Z]\d{5}$)|(^[A-HJ-NP-Z]{2}\d{4}$)|(^D\d{7}$)")]
    [string]$MRN
    ) 
}

# And finally a while example - processing log records
break
While ($_.rectype -cmatch 'Security|System'){
    #take some action here
}

#Only do if time permits - repeating groups
<#=================================
break
#Repeating groups
#Are there two 'digits' sequences in the string?
($a -match "(\D+\d+){2}")
#Are there three 'digits' sequences in the string?
($a -match "(\D+\d+){3}")
#Are there four 'digits' sequences in the string?
($a -match "(\D+\d+){4}")
===================#>
