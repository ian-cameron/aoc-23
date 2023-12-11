Imports Microsoft.VisualBasic
Imports System.IO

Module Solution
    Const FILENAME As String = "input"
    Dim start As (R As Integer, C As Integer) = (0, 0)
    Dim matrix()() As Char = {}
    Dim history()() As Char = {}
    Dim steps As Integer = 0
    Dim ended As Boolean = False

Sub Main()  
    Dim file_lines() As String = {}  
    ' Open the file and read in each line
    Using sr As New StreamReader(FILENAME)
        Dim line_text As String = sr.ReadLine()
        Dim i As Integer = 0
        While line_text IsNot Nothing
            ReDim Preserve file_lines(i)
            file_lines(i) = line_text
            line_text = sr.ReadLine()
            i += 1
        End While
    End Using
   
    ' Split each line into a 2D array of characters
    For i = 0 To UBound(file_lines)
        Dim char_array() As Char = file_lines(i).ToCharArray()
        ReDim Preserve matrix(i)
        matrix(i) = char_array

        'Create another 2D array of same size for step 2
        ReDim Preserve history(i)
        char_array = file_lines(i).ToCharArray()
        history(i) = char_array
    Next 

    FindS()
    Begin()
End Sub

' Function to find the character "S"
Function FindS()
    Dim i as Integer
    Dim j as Integer = 0
    For i = 0 To UBound(matrix)      
        For j = 0 To UBound(matrix(i))
            If matrix(i)(j) = "S" Then
                start = (i,j)
                Return True
            End If
        Next
    Next
    Return False
End Function

Function Begin()
    steps += 1
    Dim point as (R As Integer, C As Integer) = start
    Dim nextMove as (R As Integer, C As Integer)
    Dim right As Char = (matrix(start.R)(start.C+1))
    Dim left As Char = (matrix(start.R)(start.C-1))
    Dim up As Char = (matrix(start.R-1)(start.C))
    Dim down As Char = (matrix(start.R+1)(start.C))
    If (right = "7" or right = "J" or right = "-")
        nextMove = (start.R,start.C+1)
    Else If (left = "F" or left = "L" or left = "-")
        nextMove = (start.R,start.C+1)
    Else If (up = "F" or up = "7" or up = "|")
        nextMove = (start.R-1,start.C)
    Else If (down = "J" or down = "L" or down = "|")
        nextMove = (start.R+1,start.C)
    End If
    While Not Ended
        Dim lastMove = nextMove
        nextMove = ClockwiseTraverse(nextMove, point)
        point = lastMove
    End While
    Return False
End Function

Function ClockwiseTraverse(point As (R As Integer, C As Integer), from As (R As Integer, C As Integer))
    Dim row As Integer = point.R
    Dim col As Integer = point.C
    Dim pipe As Char = matrix(row)(col)
    Dim direction As Char = "U"
    ' Looped back to the start
    if pipe = "S" Then      
        Console.WriteLine("Step 1: " & steps/2)    
        Console.WriteLine("Step 2: " & FindInside)
        Ended = True
        Return (row,col)
    End If
    steps += 1
    Select Case pipe    
        Case "7"
            If from.R > row Then
                point = (row, col-1)
            Else 
                point = (row+1, col)
            End If
        Case "L"
            If from.R < row Then
                point = (row, col+1)
            Else 
                point = (row-1, col)
            End If
        Case "F"
            If from.C > col Then
                point = (row+1, col)
            Else 
                point = (row, col+1)
            End If
        Case "J"
            If from.C < col Then
                point = (row-1, col)
            Else 
                point = (row, col-1)
            End If
        Case "-"
            If from.C < col Then
                point = (row, col+1)
            Else 
                point = (row, col-1)
            End If
        Case "|"
            If from.R < row Then
                point = (row+1, col)
            Else 
                point = (row-1, col)
            End If
        Case Else
            Console.WriteLine("Unknown " & pipe)
    End Select
    ' Save Northbound pipes in history for step 2
    If (pipe = "L" or pipe = "J" or pipe = "|")
        history(row)(col) = "N"
    Else
        history(row)(col) = "*"
    End if
    Return point
End Function

' Count as inside after crossing a Northbound pipe until crossing another one
Function FindInside
    Dim insideCount As Integer = 0
    for i=0 To UBound(history)
        Dim inside As Boolean = False
        for j=0 To UBound(history(i))    
            If inside and Not history(i)(j) = "N" and Not history(i)(j) = "*"
                insideCount += 1
            End If
            If history(i)(j) = "N" Then
                inside = Not inside    
            End If
        Next
    Next
    Return insideCount
End Function
End Module