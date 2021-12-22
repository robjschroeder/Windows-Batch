@echo off
::
::Update Server Path
Set path=server.domain.com/folder
::
::---------------------------::
:::::::::::::::::::::::::::::::
::   Photoshop Installation  ::
::      Robert Schroeder     ::
::         12/12/2017        ::
:::::::::::::::::::::::::::::::
::---------------------------::
::
::=========================================================================================
:Variable-1
:: Define the required variables
SET loc=\\%path%\Photoshop
SET ver=19.0.1
IF "%loc%"=="" GOTO Loc
IF "%ver%"=="" GOTO Ver
GOTO Variable-2
::=========================================================================================
:Loc
:: Prompt for input if none is provided in command line 
CLS
ECHO The full path is needed
ECHO (i.e. \\%path%\Photoshop)
SET /P loc=Enter the source you are copying from:
IF "%loc%"=="" GOTO Loc
::=========================================================================================
:Ver
:: Prompt for input if none is provided in command line
CLS
SET /P ver=Enter the Photoshop CC "Version" (i.e. '19.0.1'):
IF "%ver%"=="" GOT Ver
::=========================================================================================
:Variable-2
:: Define the switches variable
SET switches=/qn
SET vend=Adobe
SET pkg=Photoshop
::=========================================================================================
:Cleanup1
:: This is used to Cleanup the C:\Temp Directory
:: DO NOT MODIFY THIS SECTION
IF EXIST "C:\Temp\Err.txt" DEL /Q "C:\Temp\Err.txt"
::=========================================================================================
:ChkExist
IF EXIST "C:\!!Successful Installs\%pkg%-v%ver%.txt" GOTO Err-Exist
::=========================================================================================
::OS-Ver
:: Determine Operating System and define variable
:: DO NOT MODIFY THIS SECTION
::REG.EXE QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | FIND /i "ProductName" > nul
::IF %ERRORLEVEL% NEQ 0 GOTO Err-NO-OS
::FOR /F "tokens=2*" %%A IN ('REG.EXE QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName') Do (SET prodname=%%B) > nul

::ECHO %prodname% | FINDSTR /i /C:"Windows 7"
::IF %ERRORLEVEL%==0 GOTO Copy
::ECHO %prodname% | FINDSTR /i /C:"XP"
::IF %ERRORLEVEL%==0 GOTO Copy
::GOTO Err-NO-OS
::=========================================================================================
::Windows 7
:Copy
:: Copying files used for installation
Echo Copying files used for installation.
mkdir C:\Temp\Photoshop\
XCOPY %loc%\%ver%\x64\%vend%-%pkg%CC-%ver%x64 C:\Temp\PremierePro\ /E /R /Y
If %ERRORLEVEL% NEQ 0 GOTO Err-Copy
::===========================================================================================
::Adobe Premiere Pro Build Installation
Echo installing Adobe Photoshop MSI
msiexec /i "C:\Temp\Photoshop\Build\%vend%-%pkg%CC-%ver%x64.msi" /qn
::If %ERRORLEVEL%==3010 GOTO SFlags
If %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::====================================================================================
:SFlags
:: Remove old successful install flags and publish current version flag.
Echo Deleting old Successful Installs' txt files if they exist and creating a new one.
IF EXIST "C:\!!Successful Installs\%pkg%-v%ver%.txt" DEL /F /Q "C:\!!Successful Installs\%pkg%-v%ver%.txt"

ECHO Adobe %pkg% %ver% was installed successfully on %DATE% at %TIME%. >> "C:\!!Successful Installs\%pkg%-v%ver%.txt"
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
ECHO Adobe %pkg% %ver% is already installed.
ECHO Adobe %pkg% %ver% is already installed. >> "C:\Temp\Err.txt"
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
RMDIR /S /Q "C:\Temp\Photoshop"
If %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::================================================================
:: Shortcuts Management...
del /f /Q "C:\Users\Public\Desktop\Adobe Creative Cloud.lnk"
::=========================================================================================
::Restart Computer
Echo Restart Computer
:: "C:\Windows\System32\shutdown.exe" /r /f /t 0
GOTO END
::=========================================================================================

:END
EXIT /B
