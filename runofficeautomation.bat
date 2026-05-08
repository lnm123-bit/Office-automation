@echo off
:: Change the working directory to the script's location
pushd "%~dp0"

:: Download the PowerShell script and the Office Deployment Tool XML file
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/lnm123-bit/Office-automation/11889cfd6dab07d0d648f1b3007332b9a9b81d88/Officeautomation/Officeautomation.ps1' -OutFile '%TEMP%\OfficeAutomation.ps1'"
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/lnm123-bit/Office-automation/11889cfd6dab07d0d648f1b3007332b9a9b81d88/Officeautomation/Configuration.xml' -OutFile '%TEMP%\OfficeDeployment.xml'"

:: Run the script as admin
powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%TEMP%\OfficeAutomation.ps1""' -Verb RunAs}"
popd