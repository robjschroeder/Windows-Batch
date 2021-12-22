@ECHO OFF

:: File Name: Flash-Player-Install-x32x64v2.bat
:: Created By: William Banes
:: Date Created: Jan 19, 2013
:: Modified: 04/9/14 mec6

:: Installs Flash-Player, Version and Location are passed from Kaseya, unless the .bat file is run
:: manually by the administrator.
::=========================================================================================
:Variable-1
:: Define the required variables
SET loc=%1
SET ver=%2
SET new-ver=%3
IF "%loc%"=="" GOTO Loc
IF "%ver%"=="" GOTO Ver
IF "%new-ver%"=="" GOTO new-ver
GOTO Variable-2
::=========================================================================================
:Loc
:: Prompts for input if none is provided in the command line
CLS
ECHO The full path is needed
ECHO (i.e. \\server.domain.com\path)
SET /P loc=Enter the source you are copying from:
IF "%loc%"=="" GOTO Loc
::=========================================================================================
:Ver
:: Prompts for input if none is provided in the command line
CLS
SET /P ver=Enter the Flash Player "Version" (i.e. '24.0.0.194'):
IF "%ver%"=="" GOTO Ver
::=========================================================================================
:new-Ver
:: Prompts for input if none is provided in the command line
CLS
SET /P new-ver=Enter the Adobe Flash Player "Version" that will be returned via wmic output (i.e. 24.0.0.194):
IF "%new-ver%"=="" GOTO new-ver
::=========================================================================================
:Variable-2
:: Define the required variables
SET switches=/qn /norestart
::=========================================================================================
:Cleanup
:: This is used to Cleanup the C:\Temp Directory
:: DO NOT MODIFY THIS SECTION
IF EXIST "C:\Temp\Err.txt" DEL /Q "C:\Temp\Err.txt"
::=========================================================================================
:ChkExist
Echo Checking for SFlags txt file
IF EXIST "C:\!!Successful Installs\Flash-Player %ver%.txt" GOTO Err-Exist
IF EXIST "C:\!!Successful Installs\Flash-Player v%ver%.txt" GOTO Err-Exist
::=========================================================================================
:VerCheck
Echo Checking if Flash Player is installed and if it is, checking the version
IF NOT EXIST "%windir%\system32\macromed\flash\flashutil*plugin.exe" GOTO CopyInstallers
for /f "skip=1 tokens=2 delims=," %%A in ('wmic product where "name like'Adobe Flash Player%%'" get version /format:csv') DO SET old-ver=%%A
IF %old-ver% LSS %new-ver% GOTO CopyInstallers
GOTO Err-Outdated
::=========================================================================================
:CopyInstallers
Echo Copying files used for installation
COPY /Y "%loc%"_active_x.msi "C:\Temp\Flashx.msi"
COPY /Y "%loc%"_plugin.msi "C:\Temp\Flashp.msi"
GOTO OS-Ver
::=========================================================================================
:OS-Ver
:: Determine Operating System and define variable
:: DO NOT MODIFY THIS SECTION
Echo Determining OS version
REG.EXE QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | FIND /i "ProductName" > nul
IF %ERRORLEVEL% NEQ 0 GOTO Err-NO-OS
FOR /F "tokens=2*" %%A IN ('REG.EXE QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName') Do (SET prodname=%%B) > nul
ECHO %prodname% | FINDSTR /i /C:"Windows 7"
IF %ERRORLEVEL%==0 GOTO 7-All
ECHO %prodname% | FINDSTR /i /C:"Windows 8.1"
IF %ERRORLEVEL%==0 GOTO 8-All2
ECHO %prodname% | FINDSTR /i /C:"Windows 10"
IF %ERRORLEVEL%==0 GOTO 8-All2
ECHO %prodname% | FINDSTR /i /C:"XP"
IF %ERRORLEVEL%==0 GOTO XP-All
GOTO Err-NO-OS
::=========================================================================================
::       ****************************************
::       *            Windows XP Stuff          *
::       ****************************************
::=========================================================================================
:XP-All
:: Installs Flash Player
Echo Installing Adobe Flash Player Active X control
"C:\Temp\Flashx.msi" %switches%

IF %ERRORLEVEL% EQU 0 GOTO XP-All2
IF %ERRORLEVEL% EQU 3010 GOTO XP-All2
IF %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::=========================================================================================
:XP-All2
Echo Installing Adobe Flash Player plugin
"C:\Temp\Flashp.msi" %switches%

IF %ERRORLEVEL% EQU 0 GOTO XP-All3
IF %ERRORLEVEL% EQU 3010 GOTO XP-All3
IF %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::=========================================================================================
:XP-All3
RMDIR /S /Q "%ProgramFiles%\Common Files\Adobe\ARM"

GOTO Copy
::=========================================================================================
::       ****************************************
::       *             Windows 7 Stuff          *
::       ****************************************
::=========================================================================================
:7-All
:: Installs Flash Player
Echo Installing Adobe Flash Player Active X control
"C:\Temp\Flashx.msi" %switches%

IF %ERRORLEVEL% EQU 0 GOTO 7-All2
IF %ERRORLEVEL% EQU 3010 GOTO 7-All2
IF %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::=========================================================================================
:7-All2
Echo Installing Adobe Flash Player plugin
"C:\Temp\Flashp.msi" %switches%

IF %ERRORLEVEL% EQU 0 GOTO x32-x64
IF %ERRORLEVEL% EQU 3010 GOTO x32-x64
IF %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::=========================================================================================
::       ****************************************
::       *             Windows 8 Stuff          *
::       ****************************************
::=========================================================================================
:8-All
:: Installs Flash Player
::Echo Installing Adobe Flash Player Active X control via Windows Update package, since Active X Flash Player is bundled in IE on Windows 8/8.1
::IF %PROCESSOR_ARCHITECTURE% EQU X86 COPY /Y "%loc%"_active_x-x86.msu "C:\Temp\Flashx.msu"
::IF %PROCESSOR_ARCHITECTURE% EQU AMD64 COPY /Y "%loc%"_active_x-x64.msu "C:\Temp\Flashx.msu"
::"C:\Temp\Flashx.msu" /quiet /norestart

::IF %ERRORLEVEL% EQU 0 GOTO 8-All2
::IF %ERRORLEVEL% EQU 3010 GOTO 8-All2
::IF %ERRORLEVEL% EQU 2359302 GOTO 8-All2
::IF %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::=========================================================================================
:8-All2
Echo Installing Adobe Flash Player plugin
IF EXIST "C:\Temp\flashx.msu" DEL /Q "C:\Temp\Flashx.msu"
"C:\Temp\Flashp.msi" %switches%

IF %ERRORLEVEL% EQU 0 GOTO x32-x64
IF %ERRORLEVEL% EQU 3010 GOTO x32-x64
IF %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::=========================================================================================
:x32-x64
:: Test if x64
IF NOT EXIST C:\Windows\SysWOW64 GOTO 32Bit-W7
:: Delete ARM folder and all contents.
RMDIR /S /Q "%ProgramFiles(x86)%\Common Files\Adobe\ARM"

:32Bit-W7
:: Delete ARM folder and all contents.
RMDIR /S /Q "%ProgramFiles%\Common Files\Adobe\ARM"

:: Reset ERRORLEVEL to 0
VERIFY >nul
::=========================================================================================
::       ****************************************
::       *               MISC Stuff             *
::       ****************************************
:Copy
C:
:: Copy mms.cfg to WINDOWS for user profile access for limiting preferences changes by user.
IF NOT EXIST "C:\WINDOWS\System32\Macromed\Flash" MD "C:\WINDOWS\System32\Macromed\Flash"
COPY /Y "\\%path%\mms.cfg" "C:\WINDOWS\System32\Macromed\Flash\mms.cfg" >nul
GOTO Reg

IF Exist C:\Users GOTO 7-Copy
IF Exist "C:\Documents and Settings" GOTO XP-Copy

7-Copy
:: Move preconfigured settings.sol file to home in Every Users profile
:: This sets user setting to stop autoupdate. mms.cfg sets it so user cannot change settings.
C:
FOR /f "tokens=*" %%a in ('dir /b /a:dh "%systemdrive%\Users"') do @MD "C:\Users\%%a\AppData\Roaming\Macromedia\Flash Player\macromedia.com\support\flashplayer\sys"
FOR /f "tokens=*" %%a in ('dir /b /a:dh "%systemdrive%\Users"') do @COPY /y "\\%path%\settings.sol" "%systemdrive%\Users\%%a\AppData\Roaming\Macromedia\Flash Player\macromedia.com\support\flashplayer\sys"

IF NOT EXIST "C:\Users\Public\Macromed" MD "C:\Users\Public\Macromed"
IF EXIST "C:\Users\Public\AppData" RMDIR /S /Q "C:\Users\Public\AppData"
COPY /Y "\\%path%\Autoupdate-Settings-Enable\settings.sol" "C:\Users\Public\Macromed\settings.sol"
COPY /Y "\\%path%\FlashCfgFileMove_11.4.402.265_W7.bat" "%programdata%\microsoft\windows\start menu\programs\startup"
IF %ERRORLEVEL% NEQ 0 GOTO Err-Failed
GOTO Reg

XP-Copy
:: Move preconfigured settings.sol file to home in Every Users profile
:: This sets user setting to stop autoupdate. mms.cfg sets it so user cannot change settings.
C:
FOR /f "tokens=*" %%a in ('dir /b /a:dh "%systemdrive%\Documents and Settings"') do @MD "C:\Documents and Settings\%%a\Application Data\Macromedia\Flash Player\"
FOR /f "tokens=*" %%a in ('dir /b /a:dh "%systemdrive%\Documents and Settings"') do @COPY /y "\\%path%\settings.sol" "%systemdrive%\Documents and Settings\%%a\Application Data\Macromedia\Flash Player"

IF %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::=========================================================================================
:Reg
VERIFY >nul
::=========================================================================================
:SFlags
:: Remove old successful install flags and publish current version flag.
IF EXIST "C:\!!Successful Installs\Flash-Player*.txt" DEL /F /Q "C:\!!Successful Installs\Flash-Player*.txt"
IF EXIST "C:\!!Successful Installs\Adobe Flash Play*.txt" DEL /F /Q "C:\!!Successful Installs\Adobe Flash Play*.txt"
ECHO Flash-Player %ver% was installed successfully on %DATE% at %TIME%. >"C:\!!Successful Installs\Flash-Player v%ver%.txt"
IF %ERRORLEVEL%==0 GOTO Cleanup
::=========================================================================================
:Cleanup
:: Remove all used files
IF EXIST "C:\Temp\Flash*.msi" DEL /Q "C:\Temp\Flash*.msi"
GOTO END
::=========================================================================================
::       ****************************************
::       *             Error Messages           *
::       ****************************************
:Err-Failed
:: Installation Failed
ECHO Installation Failed with exit code: %errorlevel%. >> "C:\Temp\Err.txt"
GOTO END
::=========================================================================================
:Err-NO-OS
:: Write No Operating System Error Message
ECHO No Valid Operating System Installed >> "C:\Temp\Err.txt"
GOTO END
::=========================================================================================
:Err-Exist
ECHO Flash-Player %ver% is already installed >> "C:\Temp\Err.txt"
GOTO END
::=========================================================================================
:Err-Outdated
ECHO Flash-Player %ver% is older than the version installed. >> "C:\Temp\Err.txt"
GOTO END
::=========================================================================================
:END
EXIT /B