@echo off

::Set TempDir=C:\Temp
::Set TSSTools32=C:\Program Files\TSS Tools
::Set TSSTools64=C:\Program Files (x86)\TSS Tools
Set StartupPath=%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Startup
Set LogsDirPath=C:\Logs

IF NOT EXIST "%LogsDirPath%" MKDIR "%LOGSDIRPATH%"
ICACLS "%LogsDirPath%" /inheritance:d
icacls "%LogsDirPath%" /remove:g "authenticated users"
icacls "%LogsDirPath%" /remove:d "authenticated users"

If %PROCESSOR_ARCHITECTURE% EQU x86 GOTO x86
If %PROCESSOR_ARCHITECTURE% EQU AMD64 GOTO x64
GOTO End


:x86
Echo 32-bit
xcopy /Y "%~dp0New-GroupPolicyLog.ps1" "%LogsDirPath%"
xcopy /Y "%~dp0femail.exe" "%LogsDirPath%"
xcopy /Y "%~dp0PowerShellWrapper.vbs" "%StartupPath%"
GOTO End


:x64
Echo 64-bit
xcopy /Y "%~dp0New-GroupPolicyLog.ps1" "%LogsDirPath%"
xcopy /Y "%~dp0femail.exe" "%LogsDirPath%"
xcopy /Y "%~dp0PowerShellWrapper.vbs" "%StartupPath%"
GOTO End


:End
exit /b

