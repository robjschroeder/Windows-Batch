@echo off
::Update Server Path
Set path=server.domain.com\folder
xcopy \\%path%\Test.docx %appdata% /y