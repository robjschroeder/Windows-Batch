@ECHO OFF

:: File Name: ColleagueDatatel-Desktop-Update.bat
:: Created By: Robert Schroeder
:: Date Created: July 9, 2014
::=========================================================================================
:Variable-1
:: Define Variables
SET netid=%1
SET loc=%2
IF "%netid%"=="" GOTO NetID
IF "%loc%"=="" GOTO loc
GOTO Variable-2
::=========================================================================================
:NetID
echo %netid% and %loc% >> C:\Temp\netid.txt
:: Prompts for input if none is provided in the command line
CLS
SET /P netid=Enter the users "NETID":
If "%netid%"=="" GOTO NetID
::=========================================================================================
:loc
:: Promts for input if none is provided in the command line
CLS
ECHO The full path is needed
ECHO (i.e. \\server.domain.com)
SET /P loc=Enter the Destination you are copying from:
IF "%loc%"=="" GOTO loc
::=========================================================================================
:Variable-2
SET switches= /Y /D /E /Q
SET switches2= /Y /Q /I
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
IF NOT EXIST "C:\Users\%netid%" GOTO Err-XP-User
IF NOT EXIST "C:\Documents and Settings\%netid%\Local Settings\Application Data\Datatel\Scripts\Education_Hosting" MKDIR "C:\Documents and Settings\%netid%\Local Settings\Application Data\Datatel\Scripts\Education_Hosting"

XCOPY "%loc%\Education_Hosting" "C:\Documents and Settings\%netid%\Local Settings\Application Data\Datatel\Scripts\Education_Hosting" %switches2%

IF NOT EXIST "C:\Documents and Settings\%netid%\Local Settings\Application Data\Datatel\Scripts\Production_Hosting" MKDIR "C:\Documents and Settings\%netid%\Local Settings\Application Data\Datatel\Scripts\Production_Hosting"

XCOPY "%loc%\Education_Hosting" "C:\Documents and Settings\%netid%\Local Settings\Application Data\Datatel\Scripts\Production_Hosting" %switches2%
XCOPY "%loc%\64Bit\datatel.ini" "C:\Documents and Settings\%netid%\My Documents\Datatel\" %switches2%
GOTO End
::=========================================================================================

::       ****************************************
::       *             Windows 7 Stuff          *
::       ****************************************

:W7
:: Insert Windows 7 Check Here If Needed
GOTO x32-x64
::=========================================================================================
:x32-x64
:: Test if 32 bit or 64 bit
IF NOT EXIST C:\Windows\SysWOW64 GOTO 32Bit
::=========================================================================================
:64Bit
IF NOT EXIST "C:\Users\%netid%" GOTO Err-W7-User

IF NOT EXIST "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Education_Hosting" MKDIR "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Education_Hosting"

XCOPY "%loc%\Education_Hosting" "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Education_Hosting" %switches2%
IF NOT EXIST "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Production_Hosting" MKDIR "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Production_Hosting"

XCOPY "%loc%\Production_Hosting" "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Production_Hosting" %switches2%
XCOPY "%loc%\64Bit\datatel.ini" "C:\Users\%netid%\Documents\Datatel\" %switches2%
GOTO End
::=========================================================================================
:32Bit
IF NOT EXIST "C:\Users\%netid%" GOTO Err-W7-User

IF NOT EXIST "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Education_Hosting" MKDIR "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Education_Hosting"
XCOPY "%loc%\Education_Hosting" "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Education_Hosting" %switches2%
IF NOT EXIST "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Production_Hosting" MKDIR "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Production_Hosting"

XCOPY "%loc%\Production_Hosting" "C:\Users\%netid%\AppData\Local\Datatel\Scripts\Production_Hosting" %switches2%
XCOPY "%loc%\64Bit\datatel.ini" "C:\Users\%netid%\Documents\Datatel\" %switches2%
GOTO End
::=========================================================================================
::       ****************************************
::       *             Error Messages           *
::       ****************************************

:Err-No-Image
ECHO No Image Information Stored in Registry > C:\Temp\Err.txt
GOTO End
::=========================================================================================
:Err-NO-OS
ECHO No Valid Operating System Installed > C:\Temp\Err.txt
GOTO END
::=========================================================================================
:Err-XP-User
ECHO Windows XP User Does Not Exist > C:\Temp\Err.txt
GOTO END
::=========================================================================================
:Err-W7-User
ECHO Windows 7 User Does Not Exist > C:\Temp\Err.txt
GOTO END
::=========================================================================================
:END
EXIT /B