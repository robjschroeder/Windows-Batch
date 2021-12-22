@echo off

:: Installs MS Teams
:: Created 3.13.2019 - Rjs41
::Update Server Path
Set path=server.domain.com\folder

:Architecture-Check
IF %PROCESSOR_ARCHITECTURE%==x86 GOTO :Install-32
IF %PROCESSOR_ARCHITECTURE%==AMD64 GOTO :Install-64
::=========================================================================================
:Install-32
XCOPY "\\%path%\Teams_windows.msi" "C:\Temp\" /E /R /Y
msiexec /i "C:Temp\Teams_windows.msi" OPTIONS="noAutoStart=true"
GOTO :Install-Completed
::=========================================================================================
:Install-64
XCOPY "\\%path%\Teams_windows_x64.msi" "C:\Temp\" /E /R /Y
msiexec /i "C:\Temp\Teams_windows_x64.msi" OPTIONS="noAutoStart=true"
GOTO :Install-Completed
::=========================================================================================
:Install-Completed
echo "Installation successful" >> "C:\!!Successful Installs\MS-Teams.txt"

Exit /B