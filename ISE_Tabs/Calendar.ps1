#Calendar

##Calendar permissions-

$Owner =  "Carlos Ginel:\Calendar"
$Requestor = "Zaleena Ali-Hanel"

add-MailboxFolderPermission -Identity $Owner -User $Requestor -AccessRights PublishingEditor

##Access Levels-
Owner, PublishingEditor, Editor, PublishingAuthor, Author, NonEditingAuthor, Reviewer, Contributor, AvailabilityOnly, LimitedDetails

Remove-MailboxFolderPermission -Identity $Owner -user $Requestor

##View Permissions-
Get-MailboxFolderPermission –Identity $Owner

Get-MailboxFolderPermission –Identity Dana.dunn@colonyamerican.com:\Calendar | FT identity,User, AccessRights -AutoSize

#Calendar Manipulation

Calendar permissions-
add-MailboxFolderPermission -Identity brad.hull@colonyamerican.com:\Calendar -User Melissa.Ferris@colonyamerican.com -AccessRights PublishingAuthor

##Access Levels-
##Owner PublishingEditor, Editor, PublishingAuthor, Author, NonEditingAuthor, Reviewer, Contributor, AvailabilityOnly, LimitedDetails

Remove-MailboxFolderPermission -Identity $Owner -user $Requestor

#View Permissions-
Get-MailboxFolderPermission –Identity ariel.hart@colonyamerican.com:\calendar


#Attempt at bulk retrieval of Calendar permissions


