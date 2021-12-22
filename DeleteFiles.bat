@echo off

::Set TSSTools32=C:\Program Files\TSS Tools
::Set TSSTools64=C:\Program Files (x86)\TSS Tools
::Set TempDir=C:\temp
Set LogsDirPath=C:\Logs
Set StartupPath=%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Startup
Set FileName1=PowerShellWrapper.vbs
::Set FileName2=New-GroupPolicyLog.ps1
::Set FileName3=femail.exe

If %PROCESSOR_ARCHITECTURE% EQU x86 GOTO x86
If %PROCESSOR_ARCHITECTURE% EQU AMD64 GOTO x64
GOTO End

:x86
IF Exist "%StartupPath%\%FileName1%" DEL /F /Q "%StartupPath%\%FileName1%"
IF Exist "%LogsDirPath%" rmdir /S /Q "%LogsDirPath%"

GOTO End
:x64
IF Exist "%StartupPath%\%FileName1%" DEL /F /Q "%StartupPath%\%FileName1%"
IF Exist "%LogsDirPath%" rmdir /S /Q "%LogsDirPath%"

:End
exit /b