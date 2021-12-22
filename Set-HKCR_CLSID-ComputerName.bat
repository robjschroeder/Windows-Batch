@echo off
set SetACL32=%TSSTOOLS%\setacl32.exe
set SetACL64=%TSSTOOLS%\setacl64.exe
set RegKey1=HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}
set RegKey2=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel
set RegKey3=HKU\Default User\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel
set Account1=n:\Administrators
set Account2=n:\NT Service\TrustedInstaller
set ACEPermissions1=p:full
set ACEPermissions2=p:read
set RegValue1=REG_EXPAND_SZ
set RegValue2={20D04FE0-3AEA-1069-A2D8-08002B30309D}
set RegValue3=REG_DWORD
set RegValue4=LocalizedString



IF %PROCESSOR_ARCHITECTURE%==x86 GOTO 32-bit
IF %PROCESSOR_ARCHITECTURE%==AMD64 GOTO 64-bit
GOTO End


:32-bit

%setacl32% -on "%RegKey1%" -ot reg -actn setowner -ownr "%account1%"
%setacl32% -on "%RegKey1%" -ot reg -actn ace -ace "%account1%;%ACEPermissions1%"
reg add %RegKey1% /v %RegValue4% /t %RegValue1% /d "%%COMPUTERNAME%%" /f
%setacl32% -on "%RegKey1%" -ot reg -actn ace -ace "%account1%;%ACEPermissions2%"
%setacl32% -on "%RegKey1%" -ot reg -actn setowner -ownr "%account2%"
reg add %RegKey2% /v %RegValue2% /t %RegValue3% /d 0 /f

reg add %RegKey2% /v %RegValue2% /t %RegValue3% /d 0 /f

Reg Load "HKU\Default User" "C:\Users\Default\ntuser.dat"
reg add "%RegKey3%" /v "%RegValue2%" /t "%RegValue3%" /d 0 /f
Reg Unload "HKU\Default User"
GOTO End

:64-bit

%etacl64% -on "%RegKey1%" -ot reg -actn setowner -ownr "%account1%"
%setacl64% -on "%RegKey1%" -ot reg -actn ace -ace "%account1%;%ACEPermissions1%"
reg add %RegKey1% /v %RegValue4% /t %RegValue1% /d "%%COMPUTERNAME%%" /f
%setacl64% -on "%RegKey1%" -ot reg -actn ace -ace "%account1%;%ACEPermissions2%"
%setacl64% -on "%RegKey1%" -ot reg -actn setowner -ownr "%account2%"
reg add %RegKey2% /v %RegValue2% /t %RegValue3% /d 0 /f

reg add %RegKey2% /v %RegValue2% /t %RegValue3% /d 0 /f

Reg Load "HKU\Default User" "C:\Users\Default\ntuser.dat"
reg add "%RegKey3%" /v "%RegValue2%" /t "%RegValue3%" /d 0 /f
Reg Unload "HKU\Default User"
GOTO End

:End
exit /b