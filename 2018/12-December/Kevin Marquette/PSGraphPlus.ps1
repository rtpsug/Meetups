Get-Command -Module PSGraphPlus

Show-NetworkConnectionGraph
Show-ProcessConnectionGraph
Show-ServiceDependencyGraph

Show-GitGraph
Show-GitGraph -ShowCommitMessage -Direction TopToBottom

$path = 'C:\workspace\PSGraph\output\PSGraph\PSGraph.psm1'
Show-AstCommandGraph -Path $path
