Dim WshShell, oExec 
Set WshShell = CreateObject("WScript.Shell")
 Set oExec = WshShell.Exec("calc") 
Do While oExec.Status = 0
	 WScript.Sleep 100 
Loop 
WScript.Echo oExec.Status
