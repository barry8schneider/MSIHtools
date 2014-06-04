'==========================================================================
' 
' NAME: Add STSADM to system path.vbs
' 
' AUTHOR: Gene Magerr
' EMAIL: genemagerr@hotmail.com
'
' COMMENT: This script will add the path to STSADM into the computers
'           environment variables so you can run it from a command prompt
'           without having to navigate to the BIN directory.    
'
' You have a royalty-free right to use, modify, reproduce, and
' distribute this script file in any way you find useful, provided that
' you agree that the creator, owner above has no warranty, obligations,
' or liability for such use.
' 
' VERSION HISTORY:
' 1.0   02/19/2007  Initial release
' 1.1    07/12/2008  Added functionality to remove STSADM from the path if
'                     it's currently there.
'
'==========================================================================
Option Explicit
 
'==========================================================================
' VARIABLE DECLARATIONS
'==========================================================================
Dim objShell, objNetwork, objFSO, ExistingPath, NewPath, objEnv, intAnswer1
Dim intAnswer2, DeletePath
 
Set objShell = CreateObject("WScript.Shell")
Set objNetwork = WScript.CreateObject("WScript.Network")
Set objFSO = CreateObject("Scripting.FilesystemObject")
Set objEnv = objShell.Environment("SYSTEM")
 
'==========================================================================
' STATIC VARIABLE ASSIGNMENTS
'==========================================================================
Const FOR_READING = 1, FOR_WRITING = 2, FOR_APPENDING = 8
 
'==========================================================================
' MAIN SCRIPT CODE
'==========================================================================
ExistingPath = objEnv("PATH")
 
WScript.Echo "THIS IS THE EXISTING PATH" & vbCrLf & vbCrLf & ExistingPath
If InStr(1, ExistingPath, "C:\Program Files\Common Files\Microsoft Shared\web server extensions\15\BIN", VBTextCompare) Then
intAnswer1 = MsgBox("STSADM is already in you system path" & vbCrLf & "Do you want to remove it?", vbYesNo, "Remove STSADM")
 
If intAnswer1 = vbYes Then
DeletePath = Replace(ExistingPath, ";C:\Program Files\Common Files\Microsoft Shared\web server extensions\15\BIN", "")
objEnv("Path") = DeletePath
WScript.Echo "THIS IS THE NEW MODIFIED PATH" & vbCrLf & vbCrLf & DeletePath & vbCrLf & vbCrLf &_
"If you have any questions, email me at " & vbCrLf &_
"genemagerr@hotmail.com " & vbCrLf &_
"or visit my blog at http://spadmin.spaces.live.com " & vbCrLf & vbCrLf &_
"Thanks."
Else
WScript.Echo("Nothing was modified." & vbCrLf & vbCrLf &_
"If you have any questions, email me at " & vbCrLf &_
"genemagerr@hotmail.com " & vbCrLf &_
"or visit my blog at http://spadmin.spaces.live.com " & vbCrLf & vbCrLf &_
"Thanks.")
End If 
WScript.Quit
 
Else
intAnswer2 = Msgbox("Do you want to Add STSADM to your system path?", vbYesNo, "Add STSADM")
 
If intAnswer2 = vbYes Then
   
NewPath = ExistingPath & ";C:\Program Files\Common Files\Microsoft Shared\web server extensions\15\BIN"
objEnv("PATH") = NewPath
WScript.Echo "THIS IS THE NEW MODIFIED PATH" & vbCrLf & vbCrLf & NewPath & vbCrLf & vbCrLf &_
"If you have any questions, email me at " & vbCrLf &_
"genemagerr@hotmail.com " & vbCrLf &_
"or visit my blog at http://spadmin.spaces.live.com " & vbCrLf & vbCrLf &_
"Thanks."
WScript.Quit
 
Else
WScript.Echo "You selected NO. " & vbCrLf & vbCrLf &_
"Nothing was modified." & vbCrLf & vbCrLf &_
"If you have any questions, email me at " & vbCrLf &_
"genemagerr@hotmail.com " & vbCrLf &_
"or visit my blog at http://spadmin.spaces.live.com " & vbCrLf & vbCrLf &_
"Thanks."
WScript.Quit
 
End If
End If
