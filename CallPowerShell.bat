@ECHO OFF

powershell.exe -command set-executionpolicy -executionpolicy bypass -scope process; C:\scripts\windows` powershell\work\mapnetworkdrives.ps1; pause