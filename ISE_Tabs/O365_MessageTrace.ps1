

#O365 Message Trace 

Get-MessageTrace -SenderAddress Scott.Snider@waypointhomes.com -StartDate “08/31/16 21:00” -EndDate “09/06/16 22:00” | Select-Object  MessageID, Date, Event, Action, Detail, Data, Received, SenderAddress, RecipientAddress, Subject, Status, ToIP, FromIP, Size,  MessageTraceID | Export-Csv C:\ScriptOutput\Scott.SniderMessageTrace.csv


#48 hour trace
$dateEnd = get-date 
$dateStart = $dateEnd.AddHours(-48)
Get-MessageTrace -StartDate $dateStart -EndDate $dateEnd | Select-Object Received, SenderAddress, RecipientAddress, Subject, Status, ToIP, FromIP, Size, MessageID, MessageTraceID | Export-Csv C:\ScriptOutput\48HourTest.csv



