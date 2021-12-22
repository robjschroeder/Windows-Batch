@ECHO OFF
::Update Server Path
Set path=server.domain.com\folder
msiexec /i \\%path%\CastleContentLock.msi /quiet /qn /norestart

exit