@echo off
::Update Server Path
Set path=server.domain.com\folder
regedit.exe /s /q "\\%path%\Gestetner2503.reg"
 
