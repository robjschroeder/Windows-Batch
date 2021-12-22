@echo off

:: Update Server Path
Set path=server.domain.com/folder


msiexec /i "\\%path%\AutoFile_Client.msi" /qn /norestart

msiexec /i "\\%path%\Kofax.WebCapture.Installer.msi" /qn /norestart

exit