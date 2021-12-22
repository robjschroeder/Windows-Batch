::Update Server Path
Set path=server.domain.com\folder

COPY /Y "\\%path%\ESSecureBrowser.msi" "C:\temp\"
COPY /Y "\\%path%\setup.exe" "C:\temp\"
"C:\temp\setup.exe" /quiet /passive
DEL "C:\temp\ESSecureBrowser.msi"
DEL "C:\temp\setup.exe"