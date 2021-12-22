@echo off
::
::
::---------------------------::
:::::::::::::::::::::::::::::::
:: Premiere Pro Installation ::
::      Robert Schroeder     ::
::         12/12/2017        ::
:::::::::::::::::::::::::::::::
::---------------------------::
::
::=========================================================================================
:Variable-1
:: Define the required variables
SET loc=%1
SET ver=%2
IF "%loc%"=="" GOTO Loc
IF "%ver%"=="" GOTO Ver
GOTO Variable-2
::=========================================================================================
:Loc
:: Prompt for input if none is provided in command line 
CLS
ECHO The full path is needed
ECHO (i.e. \\server.domain.com\path)
SET /P loc=Enter the source you are copying from:
IF "%loc%"=="" GOTO Loc
::=========================================================================================
:Ver
:: Prompt for input if none is provided in command line
CLS
SET /P ver=Enter the Premiere Pro CC "Version" (i.e. '12.0.0'):
IF "%ver%"=="" GOT Ver
::=========================================================================================
:Variable-2
:: Define the switches variable
SET switches=/qn
SET vend=Adobe
SET pkg=PremierePro
::=========================================================================================
:Cleanup
:: This is used to Cleanup the C:\Temp Directory
:: DO NOT MODIFY THIS SECTION
IF EXIST "C:\Temp\Err.txt" DEL /Q "C:\Temp\Err.txt"
::=========================================================================================
:ChkExist
IF EXIST "C:\!!Successful Installs\%pkg%-v%ver%.txt" GOTO Err-Exist
::=========================================================================================
:OS-Ver
:: Determine Operating System and define variable
:: DO NOT MODIFY THIS SECTION
REG.EXE QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | FIND /i "ProductName" > nul
IF %ERRORLEVEL% NEQ 0 GOTO Err-NO-OS
FOR /F "tokens=2*" %%A IN ('REG.EXE QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName') Do (SET prodname=%%B) > nul

ECHO %prodname% | FINDSTR /i /C:"Windows 7"
IF %ERRORLEVEL%==0 GOTO Copy
ECHO %prodname% | FINDSTR /i /C:"XP"
IF %ERRORLEVEL%==0 GOTO Copy
GOTO Err-NO-OS
::=========================================================================================
:Copy
:: Copying files used for installation
Echo Copying files used for installation.
XCOPY "%loc%\%ver%\x64\%vend%-%pkg%CC-%ver%x64" "C:\Temp\PremierePro\" /E /R /Y
If %ERRORLEVEL% NEQ 0 GOTO Err-Copy
::===========================================================================================
::Adobe Premiere Pro Build Installation
Echo installing Adobe Photoshop MSI
msiexec /i "C:\Temp\PremierePro\Build\%vend%-%pkg%CC-%ver%x64.msi" %switches%
If %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::====================================================================================
:SFlags
:: Remove old successful install flags and publish current version flag.
Echo Deleting old Successful Installs' txt files if they exist and creating a new one.
IF EXIST "C:\!!Successful Installs\%pkg%-v%ver%.txt" DEL /F /Q "C:\!!Successful Installs\%pkg%-v%ver%.txt"

ECHO Adobe Phothosp Creative Cloud 14 was installed successfully on %DATE% at %TIME%. >>"C:\!!Successful Installs\%pkg%-v%ver%.txt"
IF %ERRORLEVEL%==0 GOTO Cleanup
::=========================================================================================

::       ****************************************
::       *             Error Messages           *
::       ****************************************
:Err-Failed
:: Installation Failed
ECHO Installation Failed.
ECHO Installation Failed with exit code: %errorlevel%. >> "C:\Temp\Err.txt"
GOTO Cleanup
::=========================================================================================
:Err-Exist
ECHO Adobe Creative Cloud 14 is already installed.
ECHO Adobe Creative Cloud 14 is already installed. >> "C:\Temp\Err.txt"
GOTO Cleanup
::=========================================================================================
:Err-NO-OS
:: Write No Operating System Error Message
ECHO No Valid Operating System Installed.
ECHO No Valid Operating System Installed. >> "C:\Temp\Err.txt"
GOTO Cleanup
::=========================================================================================
:Err-Copy
:: Write No Operating System Error Message
ECHO Copying of files used for installation failed.
ECHO Copying of files used for installation failed. >> "C:\Temp\Err.txt"
GOTO Cleanup
::=========================================================================================
:Cleanup
::Remove all used files
RMDIR /S /Q "C:\temp\Photoshop"
If %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::================================================================
:: Shortcuts Management...
del /f /Q "C:\Users\Public\Desktop\Adobe Creative Cloud.lnk"
::=========================================================================================
::Restart Computer
Echo Restart Computer
"C:\Windows\System32\shutdown.exe" /r /f /t 0
GOTO END
::=========================================================================================

:END
EXIT /B
