@ECHO OFF

:: File Name: DropboxInstall.bat
:: Created by: Robert Schroeder
:: Date Created: Jan 8, 2015

:: Installs Dropbox on logged in user's profile
::=======================================================================================
:Variable-1
:: Define location variable ***UPDATE****
SET loc="\\server.domain.com\Dropbox"
::=======================================================================================
:CopyInstall
:: Copies the .exe for Dropbox from the server to C:\temp\
COPY /Y "%loc%\DropboxInstaller.exe" "C:\Temp\DropboxInstaller.exe"
::=======================================================================================
:Install
:: Installs Dropbox
"C:\Temp\DropboxInstaller.exe" /S

::=======================================================================================
:RemoveInstaller
:: Removes .exe from C:\temp
DEL "C:\Temp\DropboxInstaller.exe"
