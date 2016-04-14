Imports System.Messaging
Imports System.IO
Imports Microsoft
Imports Microsoft.VisualBasic
Imports Microsoft.Win32
Imports Microsoft.Win32.Registry
Public Class TriggerMagic
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub
    Friend WithEvents Button1 As System.Windows.Forms.Button

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Button1 = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'Button1
        '
        Me.Button1.Location = New System.Drawing.Point(478, 100)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(75, 23)
        Me.Button1.TabIndex = 0
        Me.Button1.Text = "Button1"
        Me.Button1.UseVisualStyleBackColor = True
        '
        'TriggerMagic
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(893, 373)
        Me.Controls.Add(Me.Button1)
        Me.Name = "TriggerMagic"
        Me.Text = "MSMQ Manager.NET"
        Me.ResumeLayout(False)

    End Sub

#End Region

    Dim pth As String
    Dim ARTrigger(400) As Trigger
    Dim ARRule(400) As rule
    Dim ARAssoc(400, 1) As String
    Dim numberoftriggers As Integer
    Dim numberofrules As Integer
    Dim numberofassoc As Integer
    
    Private Sub Create()
        Dim count, x As Integer
        Dim st, fname2, logname As String
        Dim realfile As String
        Dim fname, temp, key As String
        Dim triggerguid, t As String
        Dim ruleguid As String
        realfile = pth & "trig.bat"
        Dim sr, sr2 As StreamWriter
        Dim sr3, sr4 As StreamReader
        Dim fldr As String
        fldr = "d:\log files"
        Try
            MkDir(fldr)
        Catch

        End Try
        Try
            fname = fldr & "\TriggerMagic_log.log"
            sr = New StreamWriter(fname) ' open the log file
            sr.WriteLine("Start of log")
        Catch
            fname = "c:\" & "\TriggerMagic_log.log"
            sr = New StreamWriter(fname) ' open the log file
            sr.WriteLine("Start of log")

        End Try
        logname = "c:\trig.log"
        ' fname = pth & "triggerlog.log"
        'sr = New StreamWriter(fname) ' open the log file
        ' open the log file
        'sr.WriteLine("Start of log")
       
        Try

        
            fname2 = pth & "TRIGADM.exe"
            For x = 0 To numberoftriggers
                ARTrigger(x).guid = checktrigger(ARTrigger(x).name)

                If ARTrigger(x).guid = "" Then
                    st = fname2 + " /Request:AddTrigger /Name:" + ARTrigger(x).name + " /Queue:" + ARTrigger(x).queue + " /Enabled:" + ARTrigger(x).enabled + " /Serialized:" + ARTrigger(x).serialized + " /MsgProcess:" + ARTrigger(x).msgprocess + ">" + logname
                Else
                    ARTrigger(x).guid = trimguid(ARTrigger(x).guid)
                    st = fname2 + " /Request:deletetrigger /ID:" + ARTrigger(x).guid + ">" + logname
                    sr2 = New StreamWriter(realfile)
                    sr2.WriteLine(st)
                    sr.WriteLine(st)
                    sr2.Close()
                    Shell(realfile, AppWinStyle.Hide, True)
                    st = fname2 + " /Request:AddTrigger /Name:" + ARTrigger(x).name + " /Queue:" + ARTrigger(x).queue + " /Enabled:" + ARTrigger(x).enabled + " /Serialized:" + ARTrigger(x).serialized + " /MsgProcess:" + ARTrigger(x).msgprocess + ">" + logname
                End If
                'st = fname2 + " /Request:AddTrigger /Name:" + ARTrigger(x).name + " /Queue:" + ARTrigger(x).queue + " /Enabled:" + ARTrigger(x).enabled + " /Serialized:" + ARTrigger(x).serialized + " /MsgProcess:" + ARTrigger(x).msgprocess + ">" + logname
                sr2 = New StreamWriter(realfile)
                sr2.WriteLine(st)
                sr.WriteLine(st)
                sr2.Close()


                Shell(realfile, AppWinStyle.Hide, True)
                sr3 = New StreamReader(logname)
                ARTrigger(x).guid = sr3.ReadLine
                sr3.Close()

            Next

            For x = 0 To numberofrules
                ARRule(x).guid = checkrule(ARRule(x).name)
                If ARRule(x).guid = "" Then
                    st = fname2 + " /Request:AddRule /Name:" + ARRule(x).name + ARRule(x).args + ">" + logname
                Else
                    ARRule(x).guid = trimguid(ARRule(x).guid)
                    st = fname2 + " /Request:deleterule /ID:" + ARRule(x).guid + ">" + logname
                    sr2 = New StreamWriter(realfile)
                    sr2.WriteLine(st)
                    sr.WriteLine(st)
                    sr2.Close()
                    Shell(realfile, AppWinStyle.Hide, True)
                    st = fname2 + " /Request:AddRule /Name:" + ARRule(x).name + ARRule(x).args + ">" + logname
                End If
                sr2 = New StreamWriter(realfile)
                sr2.WriteLine(st)
                sr.WriteLine(st)
                sr2.Close()
                Shell(realfile, AppWinStyle.Hide, True)

                sr4 = New StreamReader(logname)
                t = sr4.ReadLine
                ARRule(x).guid = t
                sr4.Close()
            Next
            For x = 0 To numberofassoc
                triggerguid = gettriggerguid(ARAssoc(x, 0))
                ruleguid = getruleguid(ARAssoc(x, 1))
                st = fname2 + " /Request:AttachRule /TriggerID:" + triggerguid + " /RuleId:" + ruleguid + ">" + logname
                sr2 = New StreamWriter(realfile)
                sr2.WriteLine(st)
                sr.WriteLine(st)
                sr2.Close()
                Shell(realfile, AppWinStyle.Hide, True)
                ' sr3 = New StreamReader(logname)
                '  ARTrigger(numberoftriggers).guid = sr3.ReadLine
                ' sr3.Close()
            Next

            sr.WriteLine("End of log")
            sr.Close()
            MsgBox("Succuss.  Please see log for warnings")
            End

        Catch ex As Exception
            MsgBox("Problem creating trigger,  please see log")
            End
        End Try
    End Sub
    Private Function gettriggerguid(ByVal trigger As String) As String
        Dim x As Integer
        For x = 0 To numberoftriggers
            If ARTrigger(x).name = trigger Then Return (ARTrigger(x).guid)
        Next
        Return ""

    End Function
    Private Function getruleguid(ByVal rule As String) As String
        Dim x As Integer
        For x = 0 To numberofrules
            If ARRule(x).name = rule Then Return (ARRule(x).guid)
        Next
        Return ""
    End Function
    Private Function getlist() As Boolean

        Dim lnt As Integer
        Dim line As Integer
        Dim startnew As Boolean
        Dim computername, temp, key As String
        Dim exelen As Integer
        Dim x, y, count As Integer
        Dim t1, t2 As Integer
        Dim inprocess As Boolean
        'ARlist(0).permissions(0).perm(0) = True
        Dim f, f0, f1 As Integer
        exelen = Len("TriggerMagic")
        Dim t0, t3 As Integer
        lnt = Len(Application.ExecutablePath) - exelen - 4
        pth = Mid(Application.ExecutablePath, 1, lnt)
        Dim sr As StreamReader
        Dim fname As String
        fname = pth & "list.txt"
        numberoftriggers = -1
        numberofrules = -1
        numberofassoc = -1
        inprocess = True
        key = "SYSTEM\ControlSet001\Control\ComputerName\ComputerName"
        Dim R As Microsoft.Win32.RegistryKey = Registry.LocalMachine.OpenSubKey(key)
        R.OpenSubKey("ComputerName")
        computername = R.GetValue("ComputerName")

        Try
            sr = New StreamReader(fname)
        Catch
            MsgBox("There was a problem reading " & fname)
            End
        End Try
        computername = InputBox("Enter Computer Name", "Computer Name", computername)

        count = -1
        startnew = True
        Try
            Do

                temp = sr.ReadLine()
                If LCase(Mid(temp, 1, Len("trigger"))) = "trigger" Then
                    numberoftriggers = numberoftriggers + 1
                    ARTrigger(numberoftriggers) = New Trigger
                    f1 = findfirst(temp, "true")
                    f0 = findfirst(temp, "false")
                    f = lesserof(f0, f1)
                    t0 = Len("trigger ")
                    t3 = findfirst(Mid(temp, t0 + 1, temp.Length - 1 - t0), " ")
                    ARTrigger(numberoftriggers).name = Mid(temp, t0 + 1, t3 - 1)
                    ARTrigger(numberoftriggers).queue = Mid(temp, t3 + t0 + 1, f - t3 - t0 - 2)
                    ARTrigger(numberoftriggers).queue = computername + "\Private$\" + ARTrigger(numberoftriggers).queue
                    t1 = findfirst(Mid(temp, f, 8), " ")
                    ARTrigger(numberoftriggers).enabled = Mid(temp, f, t1 - 1)
                    t2 = findfirst(Mid(temp, t1 + 1 + f, 5), " ")
                    ARTrigger(numberoftriggers).serialized = Mid(temp, t1 + f, t2)
                    ARTrigger(numberoftriggers).msgprocess = Mid(temp, t2 + t2 + f + 1, Len(temp) + 1 - (t2 + t2 + f) - 1)
                End If
                If LCase(Mid(temp, 1, Len("rule"))) = "rule" Then
                    numberofrules = numberofrules + 1
                    ARRule(numberofrules) = New rule
                    f1 = findfirst(temp, "/")
                    f0 = findfirst(temp, (" "))
                    ARRule(numberofrules).name = Mid(temp, f0 + 1, f1 - 2 - f0)
                    ARRule(numberofrules).args = Mid(temp, f1, Len(temp) + 1 - f1)

                End If
                If LCase(Mid(temp, 1, Len("link"))) = "link" Then
                    numberofassoc = numberofassoc + 1
                    f0 = findfirst(Mid(temp, 6, temp.Length - 6), " ")
                    ARAssoc(numberofassoc, 0) = Mid(temp, 6, f0 - 1)
                    ARAssoc(numberofassoc, 1) = Mid(temp, f0 + 6, temp.Length - f0 - 5)

                End If
                line = line + 1

            Loop While Not (sr.Peek < 0)
        Catch
            MsgBox("There was a problem with the data in " & fname + " on line " + Str(line))
            End
        End Try
        sr.Close()





    End Function
    Private Function greaterof(ByVal v1 As Integer, ByVal v2 As Integer) As Integer
        If v1 > v2 Then Return v1
        If v2 > v1 Then Return v2

    End Function
    Private Function lesserof(ByVal v1 As Integer, ByVal v2 As Integer) As Integer
        If v1 = 0 Then v1 = 100
        If v2 = 0 Then v2 = 100
        If v1 < v2 Then Return v1
        If v2 < v1 Then Return v2

    End Function
    Private Function con(ByVal instr As String) As Boolean
        If instr = "0" Then Return False
        If instr = "1" Then Return True
    End Function
    Private Function findfirst(ByVal st As String, ByVal fstring As String) As Integer
        Dim x As Integer
        For x = 1 To st.Length
            If Mid(st, x, fstring.Length) = fstring Then
                Return x
            End If
        Next
        Return 0
    End Function
    Private Function trimguid(ByVal st As String) As String
        Dim x As Integer
        Dim found As Integer
        found = 1
        For x = st.Length To 0 Step -1
            If Mid(st, x, 1) = "\" Then
                found = x + 1
                Exit For
            End If
        Next
        Dim temp As String
        temp = Mid(st, found, st.Length - found + 1)
        Return Mid(st, found, st.Length - found + 1)

        Return 0
    End Function



    Private Sub Label1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub TriggerMagic_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
       
   
        getlist()
        Create()
    End Sub

    Private Sub Button1_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Create()
    End Sub
    Private Function checktrigger(ByVal triggername As String) As String
        Dim key As String
        Dim guid As String
        key = "SOFTWARE\Microsoft\MSMQ\Triggers\Data\Triggers"
        'key = "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        Debug.Assert(key.Length > 0)
        Dim i As Integer
        Dim k As String = key & vbCrLf
        Dim k1 As String = ""
        Dim R As Microsoft.Win32.RegistryKey = Registry.LocalMachine.OpenSubKey(key)
        Dim a() As String = R.GetSubKeyNames
        guid = ""
        ' go and get the values of this key
        k += GetMyKeys(key, triggername, guid)
        If guid <> "" Then
            Return guid
        End If
        ' now add each key to the return string and see of there are
        ' any more keys inside each one...
        For i = 0 To a.Length - 1
            Application.DoEvents()
            k1 = key & "\" & a(i)
            k += k1 & vbCrLf
            If Registry.LocalMachine.OpenSubKey(k1).SubKeyCount > 0 Then
                ' recursively step in this function to get all my new keys
                ' that are in this one. all variables are preserved as normally
                ' in recursive functions
                k += GetMyStrings(k1, triggername, guid)
                If guid <> "" Then
                    Return guid
                End If
            End If
        Next
        If guid <> "" Then
            Return guid
        End If
        Return ""
    End Function
    Private Function GetMyKeys(ByVal key As String, ByVal searchvalue As String, ByRef guid As String) As String
        Debug.Assert(key.Length > 0)
        Dim i, x As Integer
        Dim b As String
        Dim temp As String
        Dim k As String
        Dim kname As String
        Dim R As Microsoft.Win32.RegistryKey = Registry.LocalMachine.OpenSubKey(key)
        Dim a() As String = R.GetValueNames
        k = 0
        For i = 0 To a.Length - 1
            k += a(i) & vbCrLf
            For x = 0 To a.Length - 1
                If a(x) = "Name" Then
                    kname = key + "\" + a(x)
                    R.OpenSubKey("Name")
                    temp = R.GetValue("Name")
                    If temp = searchvalue Then
                        guid = key
                        Return guid
                    End If
                End If
            Next
        Next

        Return k.ToString
    End Function
    Private Function GetMyStrings(ByVal key As String, ByVal searchvalue As String, ByRef guid As String) As String
        Debug.Assert(key.Length > 0)
        Dim i As Integer
        Dim k As String = key & vbCrLf
        Dim k1 As String = ""
        Dim R As Microsoft.Win32.RegistryKey = Registry.LocalMachine.OpenSubKey(key)
        Dim a() As String = R.GetSubKeyNames

        ' go and get the values of this key
        k += GetMyKeys(key, searchvalue, guid)

        ' now add each key to the return string and see of there are
        ' any more keys inside each one...
        For i = 0 To a.Length - 1
            Application.DoEvents()
            k1 = key & "\" & a(i)
            k += k1 & vbCrLf
            If Registry.LocalMachine.OpenSubKey(k1).SubKeyCount > 0 Then
                ' recursively step in this function to get all my new keys
                ' that are in this one. all variables are preserved as normally
                ' in recursive functions
                k += GetMyStrings(k1, searchvalue, guid)
            End If
        Next

        Return k.ToString
    End Function
    Private Function checkrule(ByVal rulename As String) As String
        Dim key As String
        Dim guid As String
        rulename = rulename + "/Desc:Process"
        key = "SOFTWARE\Microsoft\MSMQ\Triggers\Data\Rules"

        'key = "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        Debug.Assert(key.Length > 0)
        Dim i As Integer
        Dim k As String = key & vbCrLf
        Dim k1 As String = ""
        Dim R As Microsoft.Win32.RegistryKey = Registry.LocalMachine.OpenSubKey(key)
        Dim a() As String = R.GetSubKeyNames
        guid = ""
        ' go and get the values of this key
        k += GetMyKeys(key, rulename, guid)
        If guid <> "" Then
            Return guid
        End If
        ' now add each key to the return string and see of there are
        ' any more keys inside each one...
        For i = 0 To a.Length - 1
            Application.DoEvents()
            k1 = key & "\" & a(i)
            k += k1 & vbCrLf
            If Registry.LocalMachine.OpenSubKey(k1).SubKeyCount = 0 Then
                ' recursively step in this function to get all my new keys
                ' that are in this one. all variables are preserved as normally
                ' in recursive functions
                k += GetMyStrings(k1, rulename, guid)
                If guid <> "" Then
                    Return guid
                End If
            End If
        Next
        If guid <> "" Then
            Return guid
        End If
        Return ""
    End Function
End Class

