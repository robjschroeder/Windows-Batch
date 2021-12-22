@echo off

# Update MAK Key
Set mak=MAK-Key-Here

slmgr -ipk %mak%
slmgr /ato

exit /b
