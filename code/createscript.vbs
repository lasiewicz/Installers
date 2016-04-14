Dim WshShell, bKey 
Set WshShell = WScript.CreateObject("WScript.Shell") 
key="HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer\AlwaysInstallElevated"
WshShell.RegWrite key,"1","REG_DWORD"
key="HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Installer\AlwaysInstallElevated"
WshShell.RegWrite key,"1","REG_DWORD" 