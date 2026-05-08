# Check if running as admin, if not, restart with admin rights
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Running as non-admin. Requesting admin rights..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
    exit
}

# Define Office Deployment Tool XML content
$odtXml = @"
<Configuration>
  <Add SourcePath="https://officecdn.microsoft.com/api/6.0/office_proplus_x64_en-us.img" OfficeClientEdition="64" Channel="MonthlyChannel" Version="16.0.14323.10000">
    <Display Level="None" AcceptEULA="TRUE"/>
    <Property Name="AUTOACTIVATE" Value="1"/>
    <Property Name="SharedComputerLicensing" Value="1"/>
  </Add>
</Configuration>
"@

# Download and install Office using the Office Deployment Tool
Write-Host "Downloading and installing Office..."
$installerPath = Join-Path -Path $env:TEMP -ChildPath "OfficeSetup.exe"
try {
    Invoke-WebRequest -Uri "https://officecdn.microsoft.com/api/6.0/office_proplus_x64_en-us.img" -OutFile $installerPath
    & $installerPath /configure - (ConvertTo-Json -InputObject $odtXml) /quiet
}
catch {
    Write-Host "Error: Failed to download or install Office. Error: $_"
    exit 1
}
finally {
    Remove-Item -Path $installerPath -ErrorAction SilentlyContinue
}

# Activate Office (using a KMS server, if legal in your region)
Write-Host "Activating Office..."
$kmsServer = "kms.example.com"  # Replace with a legal KMS server if applicable
try {
    & "cscript.exe" "`"$env:ProgramFiles\Microsoft Office\Office16\OSPP.VBS`" /sethst:$kmsServer
    & "cscript.exe" "`"$env:ProgramFiles\Microsoft Office\Office16\OSPP.VBS`" /act
}
catch {
    Write-Host "Error: Failed to activate Office. Error: $_"
    exit 1
}

# Auto-close after completion
Write-Host "Done! Closing in 5 seconds..."
Start-Sleep -Seconds 5
exit