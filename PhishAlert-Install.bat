@echo off
::Update Server Path
Set path=server.domain.com\folder

:: Update License Key
Set key=key

msiexec /quiet /i "\\%path%\PhishAlert.msi" LicenseKey=%key% ALLUSERS=1

EXIT /B