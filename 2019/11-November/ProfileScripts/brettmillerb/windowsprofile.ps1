# Import Mandatory Modules
Import-Module -Name Toolbox
Import-Module posh-git

# function declarations
function Open-Here { explorer $pwd }
function Set-SupportPath { Set-Location C:\support }
function Set-DocsPath { Set-Location $env:OneDrive\documents }
function Set-HomePath { Set-Location $home }
function Set-GitPath { Set-Location C:\support\git }
function Set-GitWorkPath { Set-Location C:\support\git\gitwork }
function Set-GitPersonalPath { Set-Location C:\support\git\gitpersonal }

New-Alias -Name op -value Open-Here
New-Alias -Name support -Value Set-SupportPath
New-Alias -Name docs -value Set-DocsPath
New-Alias -Name home -Value Set-HomePath
New-Alias -Name GitPath -Value Set-GitPath
New-Alias -Name Syntax -Value Get-Syntax
New-Alias -Name GitWork -Value Set-GitWorkPath
New-Alias -Name GitPersonal -Value Set-GitPersonalPath

function Sort-Reverse {
    $rank = [int]::MaxValue
    $input | Sort-Object { (--(Get-Variable rank -Scope 1).Value) }
}

# Import EditorServicesCommandSuite module only in VSCode
if ($host.name -eq 'Visual Studio Code Host') {
    Import-Module EditorServicesCommandSuite
    Import-EditorCommand -Module EditorServicesCommandSuite
    Import-CommandSuite

    #Set-PSReadLineKeyHandler -Key ([char]0x03) -Function CopyOrCancelLine
    Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardKillWord
    Set-PSReadLineKeyHandler -Chord 'Alt+D' -Function KillWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+@' -Function MenuComplete
}

# PSReadline KeyHandlers for console
Set-PSReadLineKeyHandler -Key '(', '{', '[' `
    -BriefDescription InsertPairedBraces `
    -LongDescription "Insert matching braces" `
    -ScriptBlock {
    param($key, $arg)

    $closeChar = switch ($key.KeyChar) {
        <#case#> '(' { [char]')'; break }
        <#case#> '{' { [char]'}'; break }
        <#case#> '[' { [char]']'; break }
    }

    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
}

Set-PSReadLineKeyHandler -Key ')', ']', '}' `
    -BriefDescription SmartCloseBraces `
    -LongDescription "Insert closing brace or skip" `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[$cursor] -eq $key.KeyChar) {
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)")
    }
}

Set-PSReadLineKeyHandler -Key 'Alt+(' `
    -BriefDescription ParenthesizeSelection `
    -LongDescription "Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis" `
    -ScriptBlock {
    param($key, $arg)

    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($selectionStart -ne -1) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
        [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
    }
}


# Register Argument completer for repository tab completion
Register-ArgumentCompleter -CommandName Find-Module -ParameterName Repository -ScriptBlock {
    Get-PSRepository | Select-Object -ExpandProperty Name | foreach-object {
        [System.Management.Automation.CompletionResult]::new(
            $_
        )
    }
}

# Default values to ensure I'm using our internal gallery
$PSDefaultParameterValues = @{
    "Find-Module:Repository"    = 'Internal-PSGallery'
    "Install-Module:Repository" = 'Internal-PSGallery'
}

# Posh-Git Prompt Settings 
# $GitPromptSettings.DefaultPromptPath = ' $($pwd.ToString().split("\")[-2..-1] -join "\")'
$GitPromptSettings.DefaultPromptPath = ' `u{2026}\$($pwd.Path | Split-Path -Leaf)'
$GitPromptSettings.DefaultPromptSuffix = $('`n> ' * ($nestedPromptLevel + 1))

function prompt {
    $prompt = Write-Prompt ("[{0}]" -f $((Get-Date).ToLongTimeString())) -ForegroundColor Green
    if ($lastCommand = Get-History -Count 1) {
        $prompt = Write-Prompt ("[{0:N2} ms]" -f ($lastCommand).duration.TotalMilliseconds) -ForegroundColor Cyan
    }
    $prompt += & $GitPromptScriptBlock
    $prompt
}

# Enables tab completion etc for choco
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# Allows discovery and adding type accelerators
$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")
$TAType::Add('accelerators', $TAType)

