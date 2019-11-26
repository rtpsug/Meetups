# The main takeaway from this profile script is that you can use optical character recognition (OCR) with a virtual MFA device, such as Twilio Authy, to automate credential refreshes.
# It's a rather hacky function, and it doesn't work 100% of the time, but typically it works pretty well.
# I think the inconsistencies in execution are because the MacOS window manager doesn't update the Authy window unless it's visible.

$AWSProfileName = 'profile123'

# Set the default region for AWS API calls
Set-DefaultAWSRegion -Region us-west-2
Set-AWSCredential -ProfileName $AWSProfileName -Scope Global

# Install PSIni if it's not already installed
if (!(Get-Module -ListAvailable -Name PSIni)) {
  Install-Module -Name PSIni -Scope CurrentUser -Force
}
 
### IMPORTANT: Replace this value with the Amazon Resource Name (ARN) of your MFA device
$MFADevice = 'arn:aws:iam::ACCOUNTID:mfa/IAMUSERNAME'
 
function Update-AWSSessionToken {
  [CmdletBinding()]
  param (
    [string] $TokenCode = (Get-AuthyTOTP)
  )
  if (!$TokenCode) {
    $TokenCode = Read-Host -Prompt 'Please enter your MFA token code'
  }
  $AWSSessionToken = Get-STSSessionToken -SerialNumber $MFADevice -TokenCode $TokenCode -ProfileName default
 
  $AWSCredentials = @{
    aws_access_key_id = $AWSSessionToken.AccessKeyId
    aws_secret_access_key = $AWSSessionToken.SecretAccessKey
    aws_session_token = $AWSSessionToken.SessionToken
  }
  Set-IniContent -FilePath ~/.aws/credentials -NameValuePairs $AWSCredentials -Sections $AWSProfileName | Out-IniFile -FilePath ~/.aws/credentials -Force
  Set-AWSCredential -ProfileName $AWSProfileName -Scope Global
}

function Get-AuthyTOTP {
    $TesseractOutput = '{0}/totp.txt' -f $HOME
    $ScreenshotPath = '{0}/authy.jpg' -f $HOME
     
    if (-not (brew list) -match '(?=.*getwindowid)(?=.*tesseract)') {
      brew install smokris/getwindowid/getwindowid tesseract
    }
   
    rm $TesseractOutput
   
    open "/Applications/Authy Desktop.app"
    Start-Sleep -Milliseconds 1000
    Start-Process -Wait -FilePath screencapture -ArgumentList ('-x -Jwindow -l{0} {1}' -f (GetWindowID 'Authy Desktop' 'Authy'), $ScreenshotPath)
    $null = tesseract ~/authy.jpg ~/totp
    if ((Get-Content -Raw -Path $TesseractOutput) -match '\d{3} \d{3}') {
      $matches[0] -replace ' ', ''
    }
    else {
      throw 'Couldn''t find TOTP from Authy Desktop'
    }
     
    Remove-Item -Path $TesseractOutput
  }
