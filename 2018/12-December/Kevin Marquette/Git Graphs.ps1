# Git examples
#   Git history
$git = git log --format="%h|%p|%s" -n 15 | select -SkipLast 1
$HASH = 0
$PARENT = 1
$SUBJECT = 2

graph git  @{rankdir='LR'} {
    Node @{shape='box'}

    foreach($line in $git)
    {
        $data = $line.split('|')
        Node -Name $data[$HASH] @{label=$data[$SUBJECT]}
        Edge -From $data[$PARENT].split(' ') -To $data[$HASH]
    } 
} | Export-PSGraph -ShowGraph


# Git history with branch details
$git = git log --format="%h|%p|%s" -n 15 --branches=* | select -SkipLast 1
$HASH = 0
$PARENT = 1
$SUBJECT = 2
$branches = git branch -a -v

graph git  @{rankdir='LR'} {
    Node @{shape='circle'}
    foreach($line in $git)
    {
        $data = $line.split('|')
        #Node -Name $data[$HASH] @{label=$data[$SUBJECT]}
        Edge -From $data[$PARENT].split(' ') -To $data[$HASH]
    } 
    
    Node @{shape='box';fillcolor='green';style='filled'}
    foreach($line in $branches)
    {
        if($line -match '(?<branch>[\w/-]+)\s+(?<hash>\w+) (.+)')
        {
            Node $Matches.branch 
            Edge $Matches.branch -From $Matches.hash
        }
    }
} | Export-PSGraph -ShowGraph -LayoutEngine Hierarchical



# Create html links
$graph = graph git  @{rankdir='LR'} {
    Node @{shape='box'}
    foreach($line in $git)
    {
        $data = $line.split('|')
        Node -Name $data[$HASH] @{
            label = $data[$SUBJECT]
            URL   = "https://github.com/KevinMarquette/PSGraph/commit/{0}" -f $data[$HASH]
        }
        Edge -From $data[$PARENT].split(' ') -To $data[$HASH]
    } 
    
    Node @{shape='box';fillcolor='green';style='filled'}
    foreach($line in $branches)
    {
        if($line -match '(?<branch>[\w/-]+)\s+(?<hash>\w+) (.+)')
        {
            Node $Matches.branch 
            Edge $Matches.branch -From $Matches.hash
        }
    }
} 

$graph | Export-PSGraph -DestinationPath c:\temp\x.png
$graph | Export-PSGraph -OutputFormat cmapx -DestinationPath c:\temp\x.map

# A little magic http://www.graphviz.org/content/output-formats#dcmapx
'<IMG SRC="x.png" USEMAP="#git" />'| Set-Content -Path c:\temp\x.html
Get-Content c:\temp\x.map | Add-Content -Path c:\temp\x.html
start c:\temp\x.html
