Break

#Connect to O365
$LiveCred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session
connect-msolservice -credential $LiveCred

#Disconnect O365
Remove-PSSession $Session

#Connect Msol
$msolcred = get-credential
connect-msolservice -credential $msolcred

#O365 manipulations

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

#Add rights to a mailbox

$MBX = write leah.granovskaya@colonyamericanfinance.com  
$MUser = write  Ariel.hart@colonyamerican.com

Get-Mailbox $MBX |
    Add-MailboxPermission -User $MUser -AccessRights FullAccess -InheritanceType All |
    Add-RecipientPermission -AccessRights SendAs -Trustee $MUser -Confirm:$false

#Remove rights to a mailbox
$RMBX = write Neerali.shukla@Colonyamerican.com 
$RMUser = write ariel.hart@colonyamerican.com

Remove-MailboxPermission -Identity $RMBX -User $RMUser -AccessRights FullAccess -InheritanceType All -Confirm:$false

#Set Primary email address

Set-Mailbox carlos.quintanilla@colonyamerican.onmicrosoft.com -EmailAddress SMTP:carlos.quintanilla@colonyamerican.com

#Get alias list
Get-Mailbox "CAH_Social" | Select-Object Displayname,@{Name=“EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_ -LIKE “SMTP:*”}}} | Sort |  Export-Csv C:\ScriptsOutput\SocialEmail.csv


#pull time of last Dirsync by user

$UserPrincipalName = Read-Host "Enter user principal name"
    $DirUser = Get-MsolUser -UserPrincipalName $UserPrincipalName

if ($DirUser.ImmutableId -eq $null)

{ 
Write-Host "User $UserPrincipalName in not Synced"
}

else

{
$DirUserUPNString = $DirUser.UserPrincipalName.ToString()
$DirUserDirectorySyncTimeString = $Diruser.LastDirSyncTime.ToString()
Write-Host "The user $DirUserUPNString is Synced, last Sync $DirUserDirectorySyncTimeString"
}

#List what mailboxes user has access to

get-mailbox | get-mailboxpermission -User "john.smith@colonyamerican.com" | fl identity

get-mailbox | get-mailboxpermission -User "crystal.green@colonyamerican.com" | Get-MailboxStatistics | FT Displayname, totalitemsize -AutoSize

#List user calendar access

Get-MailboxFolderPermission –Identity keshia.king@colonyamerican.com:\Calendar | FT User, AccessRights -AutoSize


#list the users
Get-MsolUser -ReturnDeletedUsers | FL UserPrincipalName,ObjectID

####################
#Audit list of usermailboxes
####################

Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize unlimited | Select-Object name, Office, UserPrincipalName | Export-Csv C:\ScriptOutput\O365UserEmailList_$((Get-Date).ToString('MM-dd-yyyy')).csv
