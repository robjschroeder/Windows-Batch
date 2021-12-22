@ECHO OFF

pushd

:: IF NOT EXIST "%userprofile%\desktop\backgrounds" MKDIR "%userprofile%\desktop\backgrounds"

copy /y "%localappdata%\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\*.*" "%userprofile%\dropbox\backgrounds"

ren "%userprofile%\dropbox\backgrounds\*.*" *.jpg
