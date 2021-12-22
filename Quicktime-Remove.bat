:: Uninstalls Quicktime no matter the version

wmic product where "name like 'Quicktime%%'" call uninstall /nointeractive