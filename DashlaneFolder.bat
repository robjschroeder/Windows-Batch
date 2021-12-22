@ECHO OFF

IF NOT EXIST C:\Windows\SysWOW64 GOTO 32BIT-W7
rmdir "C:\Program Files (x86)\Dashlane" /s /q
mkdir "C:\Program Files (x86)\Dashlane"
echo "Dashlane folder created" > C:\Temp\Dashlane.txt

:32BIT-W7
rmdir "C:\Program Files\Dashlane" /s /q
mkdir "C:\Program Files\Dashlane"
echo "Dashlane folder created" > C:\Temp\Dashlane.txt