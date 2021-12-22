@echo off
::
::
::---------------------------::
:::::::::::::::::::::::::::::::
::   ExtendScript Installation  ::
::      Robert Schroeder     ::
::         03/13/2018        ::
:::::::::::::::::::::::::::::::
::---------------------------::
::
::=========================================================================================
:Variable-1
:: Define the required variables
SET loc=%1
:: \\server.domain.com\path
SET app=%2
:: Adobe-ExtendScript
IF "%loc%"=="" GOTO Loc
IF "%app%"=="" GOTO App
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
:App
:: Prompt for input if none is provided in command line
CLS
SET /P app=Enter the application you would like to install (i.e. 'Adobe-ExtendScript'):
IF "%app%"=="" GOTO App
::=========================================================================================
:Variable-2
:: Define the switches variable
SET switches=/qn
::=========================================================================================
:Cleanup
:: This is used to Cleanup the C:\Temp Directory
:: DO NOT MODIFY THIS SECTION
IF EXIST "C:\Temp\Err.txt" DEL /Q "C:\Temp\Err.txt"
::=========================================================================================
:ChkExist
IF EXIST "C:\!!Successful Installs\%ver%.txt" GOTO Err-Exist
::=========================================================================================
:x32-x64
:: Test if x64
IF NOT EXIST C:\Windows\SysWOW64 GOTO 32Bit-W7
Echo Checking to see if OS is 64-bit
Echo 64-bit OS detected, setting x64 variable
SET OS=64
GOTO CopyInstallers
::=========================================================================================
:32Bit-W7
Echo 32-bit OS detected, setting x86 variable
SET OS=86
GOTO CopyInstallers
::=========================================================================================
::Windows 7
:CopyInstallers
:: Copying files used for installation
Echo Copying files used for installation.
mkdir C:\Temp\%app%-x%OS%
XCOPY %loc%\x%OS%\%app%-x%OS% C:\Temp\%app%-x%OS%\ /E /R /Y
If %ERRORLEVEL% NEQ 0 GOTO Err-Copy
::===========================================================================================
::Adobe Premiere Pro Build Installation
Echo Uninstalling old versions of %app%
wmic product where "name like '%%Extend%%Script%%'" call uninstall /nointeractive
Echo installing Adobe ExtendScript MSI
msiexec /i "C:\Temp\%app%-x%OS%\Build\%app%-x%OS%.msi" /qn
If %ERRORLEVEL%==3010 GOTO SFlags
If %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::====================================================================================
:SFlags
:: Remove old successful install flags and publish current version flag.
Echo Deleting old Successful Installs' txt files if they exist and creating a new one.
IF EXIST "C:\!!Successful Installs\"%app%"-x"%OS%".txt" DEL /F /Q "C:\!!Successful Installs\"%app%"-x"%OS%".txt"

ECHO %app% was installed successfully on %DATE% at %TIME%. >> "C:\!!Successful Installs\"%app%"-x"%OS%".txt"
IF %ERRORLEVEL%==0 GOTO Cleanup
Pause
::=========================================================================================
:Cleanup
::Remove all used files
RMDIR /S /Q "C:\Temp\"%app%"-x"%OS%""
:: Shortcuts Management...
del /f /Q "C:\Users\Public\Desktop\Adobe Creative Cloud.lnk"
If %ERRORLEVEL% NEQ 0 GOTO Err-Failed
GOTO END
::================================================================

::       ****************************************
::       *             Error Messages           *
::       ****************************************
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
::=========================================================================================
::Restart Computer
Echo Restart Computer
:: "C:\Windows\System32\shutdown.exe" /r /f /t 0
GOTO END
::=========================================================================================

:END
EXIT /B
