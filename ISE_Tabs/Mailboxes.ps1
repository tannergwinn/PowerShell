#Add rights to a mailbox

$MBX = "kailey.kuhl@colonyamerican.com"  
$MUser = "ariel.hart@colonyamerican.com" 

Get-Mailbox $MBX |
    Add-MailboxPermission -User $MUser -AccessRights FullAccess -InheritanceType All |
    Add-RecipientPermission -AccessRights SendAs -Trustee $MUser -Confirm:$false

#Remove rights to a mailbox
$RMBX = "kailey.kuhl@colonyamerican.com" 
$RMUser = "ariel.hart@colonyamerican.com"

Remove-MailboxPermission -Identity $RMBX -User $RMUser -AccessRights FullAccess -InheritanceType All -Confirm:$false

#Set Primary email address

Set-Mailbox Leah.granovskaya@colonyamerican.onmicrosoft.com -EmailAddress SMTP:Leah.granovskaya@colonyamericanfinance.com

#List what mailboxes user has access to

get-mailbox | get-mailboxpermission -User "john.smith@colonyamerican.com" | fl identity

#With sizes
get-mailbox | get-mailboxpermission -User "shawna.winstead@colonyamerican.com" | Get-MailboxStatistics | FT Displayname, totalitemsize -AutoSize
