Set WshShell = CreateObject("WScript.Shell")
WScript.Sleep 1000
set oShell=createobject("WScript.Shell")
pth=Session.Property("CustomActionData")
oShell.run pth, 0, true
