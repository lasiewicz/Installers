Dim WshShell, bKey
Set WshShell = WScript.CreateObject("WScript.Shell")

WshShell.RegWrite "HKCU\Software\ACME\FortuneTeller\", 1, "REG_BINARY"
WshShell.RegWrite "HKCU\Software\ACME\FortuneTeller\MindReader", "Goocher!", "REG_SZ"

bKey = WshShell.RegRead("HKCU\Software\ACME\FortuneTeller\")

WScript.Echo WshShell.RegRead("HKCU\Software\ACME\FortuneTeller\MindReader")


