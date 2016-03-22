#Calendar

##Calendar permissions-

$Owner =  "Fred Tuomi:\Calendar"
$Requestor = "Melissa Ferris"

add-MailboxFolderPermission -Identity $Owner -User $Requestor -AccessRights Owner

add-MailboxFolderPermission -Identity "Fred Tuomi:\Calendar" -User "Melissa Ferris" -AccessRights Owner

##Access Levels-
Owner, PublishingEditor, Editor, PublishingAuthor, Author, NonEditingAuthor, Reviewer, Contributor, AvailabilityOnly, LimitedDetails

Remove-MailboxFolderPermission -Identity $Owner -user $Requestor


##View Permissions-
Get-MailboxFolderPermission –Identity $Owner

Get-MailboxFolderPermission –Identity Dana.dunn@colonyamerican.com:\Calendar | FT identity,User, AccessRights -AutoSize

#Calendar Permissions for 1 user
ForEach ($mbx in Get-Mailbox) {Get-MailboxFolderPermission ($mbx.Name + ":\Calendar") | Where-Object {$_.User -like 'Ariel Hart'} | Select Identity,User,AccessRights}

#Calendar for all users in enviroment
ForEach ($mbx in Get-Mailbox) {Get-MailboxFolderPermission ($mbx.Name + “:Calendar”) | Select Identity,User,AccessRights | ft -Wrap -AutoSize}

#Calendar Manipulation

Calendar permissions-
add-MailboxFolderPermission -Identity brad.hull@colonyamerican.com:\Calendar -User Melissa.Ferris@colonyamerican.com -AccessRights PublishingAuthor

##Access Levels-
##Owner PublishingEditor, Editor, PublishingAuthor, Author, NonEditingAuthor, Reviewer, Contributor, AvailabilityOnly, LimitedDetails

Remove-MailboxFolderPermission -Identity $Owner -user $Requestor

#View Permissions-
Get-MailboxFolderPermission –Identity ariel.hart@colonyamerican.com:\calendar


#Attempt at bulk retrieval of Calendar permissions



#ShowDelegates
Get-Mailbox "arik prawer" | Get-CalendarProcessing | select ResourceDelegates

#GetDelegates



#Remove all Delegates
Get-Mailbox -identity "alias" | Set-CalendarProcessing -ResourceDelegates $null