Dim WshShell, oExec,sh
Set WshShell = CreateObject("WScript.Shell")
sh="msiexec /qb- /i \\repacksvr\transform\project\prjproe.msi transforms" & chr(61) &  chr(34) & "\\repacksvr\transform\project\pt.mst " & chr(34)

Set oExec = WshShell.Exec(sh)

Do While oExec.Status = 0
     WScript.Sleep 100
Loop 