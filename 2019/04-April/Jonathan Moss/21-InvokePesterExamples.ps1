## Pass thru

$a = Invoke-Pester -Script ./1-ShouldBe.Tests.ps1 -PassThru
$b = Invoke-Pester -Script ./2-ShouldBeExactly.Tests.ps1 -PassThru -Show Summary

## 

