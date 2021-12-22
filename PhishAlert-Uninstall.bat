@echo off
::Update Server Path
Set path=server.domain.com\folder
msiexec /x "\\%path%\PhishAlert.msi"
EXIT /B