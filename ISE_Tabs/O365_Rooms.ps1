
##List Rooms
Get-Mailbox -Filter '(RecipientTypeDetails -eq "RoomMailBox")' | Select Name,Alias | Export-csv C:\ScriptOutput\CSHRooms.csv

## Remove list of rooms

$OldRooms = "confroomcastle", "confroomranch", "confroomhacienda", "confroomigloo", "ConferenceRoomHut"

Get-MsolUser -SearchString conf | Remove-MsolUser


#Create New Rooms

$NewRooms = "Taliesin"

foreach ($NR in $Newrooms)
{

New-mailbox -Name $NR -Room
}

#SetAutoBooking **ForAllRooms

Get-MailBox | Where {$_.ResourceType -eq "Room"} | Set-CalendarProcessing -AutomateProcessing:AutoAccept

##Set calendar to show Organizer and Subject

Get-MailBox | Where {$_.ResourceType -eq "Room"} | Set-CalendarProcessing -AddOrganizerToSubject $True -DeleteComments $False -DeleteSubject $False


#Bulk add calendar permissions to a person
Get-MailBox | Where {$_.ResourceType -eq "Room"}

$Owners =   "FallingWater:\Calendar", "HearstCastle:\Calendar", "TheBreakers:\Calendar", "PaintedLadies:\Calendar", "Graceland:\Calendar", "MountVernon:\Calendar", "Taliesin:\Calendar", "WhiteHouse:\Calendar", "SouthforkRanch:\Calendar", "TheBiltmoreEstates:\Calendar"
$Requestor = "Melissa Ferris"

foreach ($Owner in $Owners)
{

add-MailboxFolderPermission -Identity $Owner -User $Requestor -AccessRights Owner
}