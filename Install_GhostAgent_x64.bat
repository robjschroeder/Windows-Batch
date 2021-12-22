@echo off
::Update Server Path
Set path=server.domain.com\folder
:: Update Ghost Server IP Address
Set IP=1.1.1.1
\\%path%\dagent_x64.msi /qn TcpAddr=%IP% TcpPort=402