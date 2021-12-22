@echo off

:: Adds entry to Hosts File

SET file=%1
SET ipaddress=%2
SET hostname=%3

echo %ipaddress% %hostname% >>%file%