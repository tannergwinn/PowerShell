#Connect to O365
$LiveCred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session
connect-msolservice -credential $LiveCred

-RecipientAddress
-SenderAddress


#O365 Message Trace 

Get-MessageTrace -SenderAddress johnraystone0147@gmail.com -StartDate “08/31/16 21:00” -EndDate “09/06/16 22:00” | Select-Object  MessageID, Date, Event, Action, Detail, Data, Received, SenderAddress, RecipientAddress, Subject, Status, ToIP, FromIP, Size,  MessageTraceID | Export-Csv C:\ScriptOutput\Scott.SniderMessageTrace.csv

#48 hour trace
$dateEnd = get-date 
$dateStart = $dateEnd.AddHours(-48)
Get-MessageTrace -StartDate $dateStart -EndDate $dateEnd | Select-Object Received, SenderAddress, RecipientAddress, Subject, Status, ToIP, FromIP, Size, MessageID, MessageTraceID | Export-Csv C:\ScriptOutput\48HourTest.csv

#7 Day trace
$dateEnd = get-date 
$dateStart = $dateEnd.AddDays(-7)
$SenderAddress = "johnraystone0147@gmail.com"
Get-MessageTrace -RecipientAddress $SenderAddress -StartDate $dateStart -EndDate $dateEnd | Select-Object Received, SenderAddress, RecipientAddress, Subject, Status, ToIP, FromIP, Size, MessageID, MessageTraceID | Export-Csv C:\ScriptOutput\MessageTrace.csv







Get-MessageTrace -SenderAddress *** Email address is removed for privacy *** -StartDate 06/13/2012 -EndDate 06/15/2012 | FL > D:\report.csv.