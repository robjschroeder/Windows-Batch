@ECHO OFF

wmic product where "name like 'zoom'" call uninstall /nointeractive