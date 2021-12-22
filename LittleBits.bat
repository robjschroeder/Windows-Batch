@echo off
::
::
:: Copies LittleBits 64-bit directory
:: By Robert Schroeder 
:: 4.19.2018

::Update Server Path
Set path=server.domain.com\folder
CLS
ECHO COPY THE LittleBits
mkdir "C:\Program Files\little Bits"
XCOPY \\%path%\littleBitsCodeKitApp "C:\Programs Files\little Bits" /E /R /Y
XCOPY \\%path%\"littleBits Code Kit.lnk" C:\Users\Public\Desktop\

ECHO ENJOY THE LittleBits

Exit /B