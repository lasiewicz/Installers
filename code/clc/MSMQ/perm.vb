Public Class perm
    Private pname As String
    Public perm(11) As Boolean

    Property name() As String
        Get
            Return pname
        End Get
        Set(ByVal value As String)
            pname = value
        End Set
    End Property
End Class
