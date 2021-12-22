:: File Name: WatchMeInstall.bat
:: Created By: Robert Schroeder
:: Date Created: September 10,2014
::=========================================================================================
:Variable-1
SET switches= /Y /D /E /Q

::Update Server Path
Set path=server.domain.com/folder

::=========================================================================================
:OS-Ver
:: Determine Operating System and define variable
REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | FIND /i "ProductName" > nul
IF %ERRORLEVEL% NEQ 0 GOTO Err-NO-OS
FOR /F "tokens=2*" %%A IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName') Do (SET prodname=%%B) > nul

ECHO %prodname% | FINDSTR /i /C:"Windows 7"
IF %ERRORLEVEL%==0 GOTO W7
ECHO %prodname% | FINDSTR /i /C:"Windows XP"
IF %ERRORLEVEL%==0 GOTO XP
GOTO Err-NO-OS
::=========================================================================================

::       ****************************************
::       *            Windows XP Stuff          *
::       ****************************************

:XP
:: Insert Windows 7 Check Here If Needed
GOTO XP-All
::=========================================================================================
:XP-All
:: Copies Updated Files To XP Computer

XCOPY "\\%path%\Watchme.exe" %switches% "C:\Documents and Settings\All Users\Desktop\"

GOTO End
::=========================================================================================

::       ****************************************
::       *             Windows 7 Stuff          *
::       ****************************************

:W7
:: Insert Windows 7 Check Here If Needed

XCOPY "\\%path%\WatchMe.exe" %switches% "C:\Users\Public\Desktop\"

GOTO End
::=========================================================================================