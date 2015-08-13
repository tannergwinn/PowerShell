#Add rights to a mailbox

$MBX = "Lynnette guck"  
$MUser = "svc_mail_Archive" 

Get-Mailbox $MBX |
    Add-MailboxPermission -User $MUser -AccessRights FullAccess -InheritanceType All |
    Add-RecipientPermission -AccessRights SendAs -Trustee $MUser -Confirm:$false

#Remove rights to a mailbox
$RMBX = "Michael Nash" 
$RMUser = "Ariel hart"

    Remove-MailboxPermission -Identity $RMBX -User $RMUser -AccessRights FullAccess -InheritanceType All -Confirm:$false|
    Remove-RecipientPermission -AccessRights SendAs -Trustee $RMUser -Confirm:$false

#Set Primary email address

Set-Mailbox Leah.granovskaya@colonyamerican.onmicrosoft.com -EmailAddress SMTP:Leah.granovskaya@colonyamericanfinance.com

#List what mailboxes user has access to

get-mailbox | get-mailboxpermission -User "john.smith@colonyamerican.com" | fl identity

#With sizes
get-mailbox | get-mailboxpermission -User "lynette guck" | Get-MailboxStatistics | FT Displayname, totalitemsize -AutoSize

# Bulk add users to mail group
$AMembers = "Victoria Greene",	"Terry Piard",	"Nicole Donowick"

foreach ($AMember in $Amembers)
{
Add-DistributionGroupMember "Property Management – HOA Distribution List" -Member $AMember -BypassSecurityGroupManagerCheck
}