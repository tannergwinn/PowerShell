#Calendar

##Calendar permissions-

$Owner = write arik.prawer@colonyamerican.com:\Calendar
$Requestor = write amy.steiner@colonyamerican.com 

add-MailboxFolderPermission -Identity $Owner -User $Requestor -AccessRights PublishingAuthor

##Access Levels-
Owner, PublishingEditor, Editor, PublishingAuthor, Author, NonEditingAuthor, Reviewer, Contributor, AvailabilityOnly, LimitedDetails

Remove-MailboxFolderPermission -Identity $Owner -user $Requestor

##View Permissions-
Get-MailboxFolderPermission –Identity $owner

Get-MailboxFolderPermission –Identity Dana.dunn@colonyamerican.com:\Calendar | FT User, AccessRights -AutoSize

#Calendar Manipulation

Calendar permissions-
add-MailboxFolderPermission -Identity brad.hull@colonyamerican.com:\Calendar -User Melissa.Ferris@colonyamerican.com -AccessRights PublishingAuthor

##Access Levels-
##Owner PublishingEditor, Editor, PublishingAuthor, Author, NonEditingAuthor, Reviewer, Contributor, AvailabilityOnly, LimitedDetails

Remove-MailboxFolderPermission -Identity user@mycompany:\calendar -user myuser@mycompany.com

#View Permissions-
Get-MailboxFolderPermission –Identity ariel.hart@colonyamerican.com:\calendar