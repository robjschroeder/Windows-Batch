@ECHO OFF
::
::
::Update Server Path
Set path=server.domain.com/folder
::
::==============================================================
:ChkExist
IF EXIST "C:\!!Successful Installs\PhotoshopCC14.txt" GOTO Err-Exist
::=========================================================================================
:OS-Ver
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
:Copy
:: Copying files used for installation
Echo Copying files used for installation.
XCOPY "\\%path%\Adobe Photoshop x64" "C:\Temp\Photoshop\" /E /R /Y
If %ERRORLEVEL% NEQ 0 GOTO Err-Copy
::===========================================================================================
::Adobe Photoshop Build Installation
Echo installing Adobe Photoshop MSI
msiexec /i "C:\Temp\Photoshop\Build\Adobe Photoshop CC.msi" /qn

If %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::====================================================================================
:Photoshop14-Install
::Echo Installing Adobe Photoshop Payloads
::"C:\Temp\Photoshop\Exceptions\ExceptionDeployer.exe" --workflow=install --mode=post
::If %ERRORLEVEL% NEQ 0 GOTO Err-Failed
::====================================================================================
:SFlags
:: Remove old successful install flags and publish current version flag.
Echo Deleting old Successful Installs' txt files if they exist and creating a new one.
IF EXIST "C:\!!Successful Installs\PhotoshopCC*.txt" DEL /F /Q "C:\!!Successful Installs\AdobePhotoshopCC*.txt"

ECHO Adobe Photoshop Creative Cloud 14 was installed successfully on %DATE% at %TIME%. >>"C:\!!Successful Installs\PhotoshopCC14.txt"
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
::del /f /Q "C:\Users\Public\Desktop\Adobe Creative Cloud.lnk"
COPY "\\%path%\Photoshop CC.lnk" "C:\Users\Public\Desktop\"
::=========================================================================================
::Restart Computer
Echo Restart Computer
"C:\Windows\System32\shutdown.exe" /r /f /t 0
GOTO END
::=========================================================================================

:END
EXIT /B
