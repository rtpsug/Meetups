
<#

    11 concepts, 16 demos + PS Core bonus round

    Demos may have unexpected results (and that's fine)

#>

#region Example Setup
Add-Type -Path 'C:\temp\Selenium\WebDriver.dll'

$Global:Selenium = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$Url = 'http://localhost'

Start-RunBucket -Control {Start-Sleep -Milliseconds 5} -Variation {} -Title 'Example'

$Global:Selenium.Navigate().GoToUrl($Url)

$ErrorActionPreference = 'SilentlyContinue'
#endregion
