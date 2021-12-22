@echo off

# Update Server Path
Set path=server.domain.com/folder

%path%\AcroRdrDC1801120040_en_US.exe /sAll /rs /l /msi "/qb-! /norestart ALLUSERS=1 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"

exit
