Dim oFileSystem, oInFileStream, oOutFileStream
Set oFileSystem = CreateObject("Scripting.FileSystemObject")

Dim strInFile
strInFile = "..\Zeepe\res\html\frame.html"

Dim strOutFile
strOutFile = "..\Zeepe\res\html\frame_modemonly.html"

If oFileSystem.FileExists(oFileSystem.GetAbsolutePathName(strInFile)) = False Then
	Wscript.Quit 1
End If

Const ForReading = 1	
Set oInFileStream = oFileSystem.OpenTextFile(strInFile, ForReading)

Set oOutFileStream = oFileSystem.CreateTextFile(strOutFile, True)

Dim strLine

Dim oRegExpStartSection
Set oRegExpStartSection = New RegExp
Dim colLineMatchesStartSection

Dim oRegExpEndSection
Set oRegExpEndSection = New RegExp
Dim colLineMatchesEndSection

oRegExpStartSection.Pattern = ".*Begin section to be stripped from Dell builds.*"
oRegExpEndSection.Pattern = ".*End section to be stripped from Dell builds.*"

Dim bStripSection: bStripSection = False

While (oInFileStream.AtEndofStream = False)
	strLine = oInFileStream.ReadLine()
	
	Set colLineMatchesStartSection = oRegExpStartSection.Execute(strLine)
	Set colLineMatchesEndSection = oRegExpEndSection.Execute(strLine)

	If (colLineMatchesStartSection.Count > 0) Then
		bStripSection = True
	ElseIf (colLineMatchesEndSection.Count > 0) Then
		bStripSection = False
	Else
		If bStripSection = False Then
			oOutFileStream.WriteLine(strLine)
		End If
	End If
Wend

Call oInFileStream.Close()
Call oOutFileStream.Close()

Call oFileSystem.CopyFile(strOutFile, strInFile, True)
