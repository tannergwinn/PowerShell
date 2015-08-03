#Add rights to a mailbox

$MBX = "Utilities@colonyamerican.com"  
$MUser = "svc_mail_archive@colonyamerican.com" 

Get-Mailbox $MBX |
    Add-MailboxPermission -User $MUser -AccessRights FullAccess -InheritanceType All |
    Add-RecipientPermission -AccessRights SendAs -Trustee $MUser -Confirm:$false

#Remove rights to a mailbox
$RMBX = "Claire.caldwell@colonyamerican.com" 
$RMUser = "svc_mail_archive@colonyamerican.com"

    Remove-MailboxPermission -Identity $RMBX -User $RMUser -AccessRights FullAccess -InheritanceType All -Confirm:$false|
    Remove-RecipientPermission -AccessRights SendAs -Trustee $RMUser -Confirm:$false

#Set Primary email address

Set-Mailbox Leah.granovskaya@colonyamerican.onmicrosoft.com -EmailAddress SMTP:Leah.granovskaya@colonyamericanfinance.com

#List what mailboxes user has access to

get-mailbox | get-mailboxpermission -User "john.smith@colonyamerican.com" | fl identity

#With sizes
get-mailbox | get-mailboxpermission -User "svc_mail_archive@colonyamerican.com" | Get-MailboxStatistics | FT Displayname, totalitemsize -AutoSize
