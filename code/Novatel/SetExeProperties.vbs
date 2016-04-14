Dim strReleaseVersion
Dim strBuildNumber
Dim strProductName
Dim strFileDescription
Dim strExeName
Dim strLegalCopyright

' Check for help request
If Wscript.Arguments.Count > 0 Then
	If Wscript.Arguments(0) = "/?" Or Wscript.Arguments(0) = "-?" Then
		Wscript.Echo "SetExeProperties.vbs <ReleaseVersion> <Product Name> <Exe name> <FileVersion> <LegalCopyright>"
	End If
End If

strLegalCopyright = "© Copyright 2002 - 2006 Novatel Wireless Inc.  All rights reserved."

' Get the command-line arguments
If Wscript.Arguments.Count < 4 Then
	strBuildNumber = "0"
Else
	strBuildNumber = "Build: " & Wscript.Arguments(3)
End If

If Wscript.Arguments.Count < 3 Then
	strExeName = "MobiLink.exe"
Else
	strExeName = Wscript.Arguments(2)
End If

If Wscript.Arguments.Count < 2 Then
	strProductName = "MobiLink"
	strFileDescription = "MobiLink Network Connection Manager"
Else
	strProductName = Wscript.Arguments(1)
	strFileDescription = Wscript.Arguments(1)
End If

If Wscript.Arguments.Count < 1 Then
	strReleaseVersion = "0,0,0,0"
Else
	strReleaseVersion = Wscript.Arguments(0)
	' Replace periods with commas to conform to Zeepe spec
	strReleaseVersion = Replace(strReleaseVersion, ".", ",")
End If

Dim oFileSystem, oInFileStream, oOutFileStream
Set oFileSystem = CreateObject("Scripting.FileSystemObject")

Dim strInFile
strInFile = "..\Zeepe\WebGeneric.hhp"

Dim strOutFile
strOutFile = "..\Zeepe\out.hhp"

If oFileSystem.FileExists(oFileSystem.GetAbsolutePathName(strInFile)) = False Then
	Wscript.Quit 1
End If

Const ForReading = 1	
Set oInFileStream = oFileSystem.OpenTextFile(strInFile, ForReading)

Set oOutFileStream = oFileSystem.CreateTextFile(strOutFile, True)

Dim strLine

Dim oRegExpProductVersion
Set oRegExpProductVersion = New RegExp
Dim colLineMatchesProductVersion

Dim oRegExpFileVersion
Set oRegExpFileVersion = New RegExp
Dim colLineMatchesFileVersion

Dim oRegExpProductName
Set oRegExpProductName = New RegExp
Dim colLineMatchesProductName

Dim oRegExpFileDescription
Set oRegExpFileDescription = New RegExp
Dim colLineMatchesFileDescription

Dim oRegExpTitle
Set oRegExpTitle = New RegExp
Dim colLineMatchesTitle

Dim oRegExpExeFile
Set oRegExpExeFile = New RegExp
Dim colLineMatchesExeFile

Dim oRegExpInternalName
Set oRegExpInternalName = New RegExp
Dim colLineMatchesInternalName

Dim oRegExpLegalCopyright
Set oRegExpLegalCopyright = New RegExp
Dim colLineMatchesLegalCopyright

oRegExpProductVersion.Pattern = ".*ProductVersion=.*"
oRegExpFileVersion.Pattern = ".*FileVersion=.*"
oRegExpProductName.Pattern = ".*ProductName=.*"
oRegExpFileDescription.Pattern = ".*FileDescription=.*"
oRegExpTitle.Pattern = ".*Title=.*"
oRegExpExeFile.Pattern = ".*Exe file=.*"
oRegExpInternalName.Pattern = ".*InternalName=.*"
oRegExpLegalCopyright.Pattern = ".*LegalCopyright=.*"

While (oInFileStream.AtEndofStream = False)
	strLine = oInFileStream.ReadLine()
	
	Set colLineMatchesProductVersion = oRegExpProductVersion.Execute(strLine)
	Set colLineMatchesFileVersion = oRegExpFileVersion.Execute(strLine)
	Set colLineMatchesProductName = oRegExpProductName.Execute(strLine)
	Set colLineMatchesFileDescription = oRegExpFileDescription.Execute(strLine)
	Set colLineMatchesTitle = oRegExpTitle.Execute(strLine)
	Set colLineMatchesExeFile = oRegExpExeFile.Execute(strLine)
	Set colLineMatchesInternalName = oRegExpInternalName.Execute(strLine)
	Set colLineMatchesLegalCopyright = oRegExpLegalCopyright.Execute(strLine)

	If (colLineMatchesProductVersion.Count > 0) Then
		oOutFileStream.WriteLine("ProductVersion=" + strReleaseVersion)
	ElseIf (colLineMatchesFileVersion.Count > 0) Then
		oOutFileStream.WriteLine("FileVersion=" + strReleaseVersion)
	ElseIf (colLineMatchesProductName.Count > 0) Then
		oOutFileStream.WriteLine("ProductName=" + strProductName)
	ElseIf (colLineMatchesFileDescription.Count > 0) Then
		oOutFileStream.WriteLine("FileDescription=" + strFileDescription)
	ElseIf (colLineMatchesTitle.Count > 0) Then
		oOutFileStream.WriteLine("Title=" + strProductName)
	ElseIf (colLineMatchesExeFile.Count > 0) Then
		oOutFileStream.WriteLine("Exe file=" + strExeName)
	ElseIf (colLineMatchesInternalName.Count > 0) Then
		oOutFileStream.WriteLine("InternalName=" + strExeName + " " + strBuildNumber)
	ElseIf (colLineMatchesLegalCopyright.Count > 0) Then
		oOutFileStream.WriteLine("LegalCopyright=" + strLegalCopyright)

	Else
		oOutFileStream.WriteLine(strLine)
	End If
Wend
