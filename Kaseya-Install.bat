@echo off

:: Installs the Kaseya Agent v 9.5.0.2
::Update Server Path
Set path=server.domain.com\folder
:: Update Kaseya Group OU
Set OU=group.computers.domain

\\%path%\KcsSetup.exe /e /c /g=%OU% /s

exit /b