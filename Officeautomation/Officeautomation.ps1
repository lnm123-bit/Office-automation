# Check if running as admin, if not, restart with admin rights
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
    exit
}

# Download and install Office (using official Microsoft links)
Write-Host "Downloading Office..."
$officeUrl = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365ProPlusRetail&platform=x64&language=en-us&version=O16GA"
$installerPath = "$env:TEMP\OfficeSetup.exe"
Invoke-WebRequest -Uri $officeUrl -OutFile $installerPath
Start-Process -FilePath $installerPath -ArgumentList "/configure `"$PSScriptRoot\configuration.xml`"" -Wait

# Activate Office (using a KMS server, if legal in your region)
Write-Host "Activating Office..."
$kmsServer = "kms.example.com"  # Replace with a legal KMS server if applicable
Start-Process "cscript.exe" -ArgumentList "`"$env:ProgramFiles\Microsoft Office\Office16\OSPP.VBS`" /sethst:$kmsServer" -Wait
Start-Process "cscript.exe" -ArgumentList "`"$env:ProgramFiles\Microsoft Office\Office16\OSPP.VBS`" /act" -Wait

# Auto-close after completion
Write-Host "Done! Closing in 5 seconds..."
Start-Sleep -Seconds 5
exit