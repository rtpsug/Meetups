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
        EDGE -From $data[$PARENT].split(' ') -To $data[$HASH]
    } 
} | Export-PSGraph -ShowGraph


# Git history with branch details
$git = git log --format="%h|%p|%s" -n 15 --branches=* | select -SkipLast 1
$HASH = 0
$PARENT = 1
$SUBJECT = 2
$branches = git branch -a -v

graph git  @{rankdir='LR'} {
    Node @{shape='rect'}
    foreach($line in $git)
    {
        $data = $line.split('|')
        #Node -Name $data[$HASH] @{label=$data[$SUBJECT]}
        Edge -From $data[$PARENT].split(' ') -To $data[$HASH]
    } 

    foreach($line in $branches)
    {
        if($line -match '(?<branch>[\w/-]+)\s+(?<hash>\w+) (.+)')
        {
            Node $Matches.branch @{fillcolor='green';style='filled'}
            Edge $Matches.branch -To $Matches.hash
        }
    }
} | Export-PSGraph -ShowGraph -LayoutEngine Hierarchical

