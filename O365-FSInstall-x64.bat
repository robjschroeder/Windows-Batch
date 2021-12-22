@echo off
::Update Server Path
Set path=server.domain.com\folder

"\\%path%\setup.exe" /configure "\\%path%\FS-installconfig-64.xml"

Exit /B