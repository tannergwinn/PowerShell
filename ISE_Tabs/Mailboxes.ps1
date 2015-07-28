﻿#Add rights to a mailbox

$MBX = write @colonyamerican.com  
$MUser = write  ariel.hart@colonyamerican.com 

Get-Mailbox $MBX |
    Add-MailboxPermission -User $MUser -AccessRights FullAccess -InheritanceType All |
    Add-RecipientPermission -AccessRights SendAs -Trustee $MUser -Confirm:$false

#Remove rights to a mailbox
$RMBX = write leah.granovskaya@colonyamericanfinance.com 
$RMUser = write ariel.hart@colonyamerican.com

Remove-MailboxPermission -Identity $RMBX -User $RMUser -AccessRights FullAccess -InheritanceType All -Confirm:$false

#Set Primary email address

Set-Mailbox Leah.granovskaya@colonyamerican.onmicrosoft.com -EmailAddress SMTP:Leah.granovskaya@colonyamericanfinance.com

