' Name : enumeratenestedgroup.vbs
' Description : script to enumerate the members of a nested group
' Author : dirk adamsky - deludi bv
' Version : 2.2 replaced the subroutine statement with a function statement
' Date : 07-06-2011
' 20120402 schneiderbi

Const filInputName = "Groups.txt"
filOutputName = "Membership-"&Dateyyyymmdd(date)&"-"&hour(now)&Minute(now)&".csv"

Dim objDomain, fso, filInput, filOutput,objComputer, objService, strGroupLevel

Set fso = WScript.CreateObject("Scripting.FileSystemObject")
Set filInput = fso.OpenTextFile(filInputName)
Set filOutput = fso.CreateTextFile(filOutputName)
Set objShell = CreateObject("Wscript.Shell")

On Error Resume Next

filOutput.WriteLine "Group, Nested Group, Members"

Do Until filInput.AtEndOfStream

strGroups = filInput.ReadLine

strGroup = Split(strGroups,"/")

strGroupName = strGroup(1)

strDomain = strGroup(0)

'Wscript.Echo strDomain
'Wscript.Echo strGroupName
'Wscript.Echo strDomain, strGroupName

'strGroupLevel = strGroupName 

'strTargetGroupDN = "LDAP://CN="&strGroups&",OU=Groups,OU=SIO MOSS,OU=Enterprise Services,DC=appservices,DC=state,DC=sbu"
'strTargetGroupDN = "LDAP://CN=CCS PSO Admin Team,OU=Groups,OU=SIO MOSS,OU=Enterprise Services,DC=appservices,DC=state,DC=sbu"

 
Set oConnection = CreateObject("ADODB.Connection")  
oConnection.Provider = "ADsDSOObject"  
oConnection.Open "Active Directory Provider"  
sGroup = strGroups   
Set oRs = oConnection.Execute("SELECT adspath " & _ 
	 "FROM 'LDAP://" & strDomain & "'" & _ 
	 "WHERE objectCategory='group' AND " & _
	 "Name='" & strGroupName & "'")  
If Not oRs.EOF Then   
sAdsPath = oRs("adspath")   
' msgbox(sAdspath)     
Else   
msgbox("Not in AD")  
End If 
 
strTargetGroupDN = sAdsPath


EnumNestedgroup strTargetGroupDN,strGroupName   

Loop


Function EnumNestedgroup(strGroupDN,strGroupLevel)
	
	Set objGroup = GetObject(strGroupDN)
	For Each objMember in objGroup.Members
		If (LCase(objMember.Class) = "group") Then
			'wscript.echo objMember.userPrincipalName, objMember.AdsPath
			filOutput.WriteLine strGroupLevel&", "&objMember.sAMAccountName

			'strGroupLevel = strGroupLevel&"***"&objMember.sAMAccountName
			EnumNestedgroup objMember.AdsPath,strGroupLevel&"***"&objMember.sAMAccountName
			
		Else
			'Wscript.Echo strGroupLevel&", "&objMember.userPrincipalName

			filOutput.WriteLine strGroupLevel&", "&objMember.userPrincipalName

		End If
	Next
	Set objGroup = Nothing
End Function

' // * Changes the date from mm/dd/yyyy to yyyymmdd * //
Function Dateyyyymmdd(strDate)
	Dim strDatePieces
 
	strDatePieces = Split(strDate, "/")
	If strDatePieces(0) < 10 Then
		strDatePieces(0) = "0" & strDatePieces(0)
	End If
 
	If strDatePieces(1) < 10 Then
		strDatePieces(1) = "0" & strDatePieces(1)
	End If
 
	Dateyyyymmdd = strDatePieces(2) & _
		strDatePieces(0) & _
		strDatePieces(1)
 
End Function ' Dateyyyymmdd 
