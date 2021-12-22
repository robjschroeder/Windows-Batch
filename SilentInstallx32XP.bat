::W7
:: Check Existence of User
::IF NOT EXIST "C:\Users\%netid%\ntuser.ini" GOTO Err-W7-User
::=========================================================================================
::W7-Image
:: Check for existence of NetID entered
::IF EXIST "C:\Users\%netid%" GOTO 7-Install
::GOTO Err-W7-No-User
::=========================================================================================

:: Update Server Path
Set path=server.domain.com/folder

:XP-Install
:: Makes directories, copies files, creates shortcuts, adds permissions
ECHO Installing Synoptix 7.0.04 ...
ECHO Copying Files to C:\Program Files ...
IF NOT EXIST "C:\Program Files\Synoptix" MD "C:\Program Files\Synoptix"
ROBOCOPY "\\%path%\Synoptix" "C:\Program Files\Synoptix" /E /NP
ECHO Copying Files to C:\Documents and Settings\%netid% ...
IF NOT EXIST "C:\Documents and Settings\%netid%\.Synoptix for ellucian" MD "C:\Documents and Settings\%netid%\.Synoptix for ellucian"
XCOPY "\\%path%\.Synoptix for ellucian" "C:\Documents and Settings\%netid%\.Synoptix for ellucian" /E /I /Q /F /H /R /Y
ECHO Creating Shortcuts ...
IF NOT EXIST "C:\Documents and Settings\%netid%\Start Menu\Programs\Synoptix" MD "C:\Documents and Settings\%netid%\Start Menu\Programs\Synoptix"
XCOPY "\\%path%\Synoptix.lnk" "C:\Documents and Settings\%netid%\Start Menu\Programs\Synoptix" /I /Q /F /Y
XCOPY "\\%path%\Synoptix.lnk" "C:\Documents and Settings\All Users\Desktop" /I /Q /F /Y
ECHO Adding Permissions ...
ICACLS "C:\Program Files\Synoptix" /q /grant Users:(OI)(CI)(M)
GOTO END