:: VLC Install
:: Created by rjs41 - 8.2.2018

@echo off
:Variable-1
:: Variables passed down from Kaseya
SET loc=%1
SET ver=%2
IF "%loc%"=="" GOTO Loc
IF "%ver%"=="" GOTO Ver
GOTO Variable-2

:Loc
:: Prompts for input if none is provided in the command line
CLS
Echo The full path is needed
echo (i.e. \\server.domain.com\path)
Set /P Loc=Enter the source you are copying from:
IF "%loc%"=="" GOTO Loc

:Ver
:: Prompts for input if none is provided in the command line
CLS
SET /P ver=Enter the VLC "version" (i.e. '3.0.3'):
IF "%ver%"=="" GOTO Ver 

:Variable-2
SET switches=/L=1033 /S

:Cleanup
IF EXIST "C:\Temp\Err.txt" DEL "C:\Temp\Err.txt"

:ChkExist
Echo Checking for SFlags txt file
IF EXIST "C:\!!Successful Installs\VLC v%ver%.txt" GOTO Err-Exist

:CopyInstallers
Echo Copying files used for installation
COPY /Y "%loc%\%ver%\vlc-%ver%-win32.exe" "C:\Temp\VLC.exe"
IF %ERRORLEVEL% NEQ 0 GOTO Err-Copy
GOTO Install

:Install
"C:\Temp\VLC.exe" %switches%
IF %ERRORLEVEL% NEQ 0 GOTO Err-Failed

:SFlags
Echo Deleting old successful installs txt file if they exist and creating a new one
IF EXIST "C:\!!Successful Installs\VLC v%ver%.txt" DEL /F /Q "C:\!!Successful Installs\VLC v%ver%.txt"
ECHO VLC v%ver% was installed on %DATE% at %TIME%. >> "C:\!!Successful Installs\VLC v%ver%.txt"
IF %ERRORLEVEL%==0 GOTO Cleanup

:Cleanup
DEL /f /q "C:\Temp\VLC.exe"
IF %ERRORLEVEL% NEQ 0 GOTO Err-Failed
GOTO END

:Err-Failed
:: Installation Failed
ECHO Installation Failed.
ECHO Installation Failed with exit code: %errorlevel%. >> "C:\Temp\Err.txt"
GOTO END
::=========================================================================================
:Err-Exist
ECHO Adobe "%pkg%" "%ver%" is already installed.
ECHO Adobe "%pkg%" "%ver%" is already installed. >> "C:\Temp\Err.txt"
GOTO END
::=========================================================================================
:Err-NO-OS
:: Write No Operating System Error Message
ECHO No Valid Operating System Installed.
ECHO No Valid Operating System Installed. >> "C:\Temp\Err.txt"
GOTO END
::=========================================================================================
:Err-Copy
:: Write No Operating System Error Message
ECHO Copying of files used for installation failed.
ECHO Copying of files used for installation failed. >> "C:\Temp\Err.txt"
GOTO END

:END
EXIT /B
