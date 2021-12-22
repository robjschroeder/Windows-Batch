@ECHO OFF
%SystemRoot%\System32\taskkill.exe /f /im chrome.exe
%SystemRoot%\System32\taskkill.exe /f /im GoogleUpdate.exe
::for /d %%A in (C:\Users\*) do (if exist "%%A\AppData\Local\Google\Chrome\" "\\server.domain.com\setup.exe" --uninstall --multi-install --chrome --force-uninstall)
for /d %%A in (C:\Users\*) do (if exist "%%A\AppData\Local\Google\Chrome" rd "%%A\AppData\Local\Google\Chrome" /s /q)
for /d %%A in (C:\Users\*) do (if exist "%%A\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome\Google Chrome.lnk" del "%%A\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome\Google Chrome.lnk" /q)
for /d %%A in (C:\Users\*) do (if exist "%%A\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome" rd "%%A\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome" /s /q)
for /d %%A in (C:\Users\*) do (if exist "%%A\Desktop\Google Chrome.lnk" del "%%A\Desktop\Spotify.lnk" /q)
