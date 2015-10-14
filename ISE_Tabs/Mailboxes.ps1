#Add rights to a mailbox

$MBX = "Dallas"  
$MUser = "Cheryl Bloxam" 

Get-Mailbox $MBX |
    Add-MailboxPermission -User $MUser -AccessRights FullAccess -InheritanceType All |
    Add-RecipientPermission -AccessRights SendAs -Trustee $MUser -Confirm:$false

#Remove rights to a mailbox
$RMBX = "DiscoverySearchMailbox{D919BA05-46A6-415f-80AD-7E09334BB852}" 
$RMUser = "Ariel Hart"

    Remove-MailboxPermission -Identity $RMBX -User $RMUser -AccessRights FullAccess -InheritanceType All -Confirm:$false |
    Remove-RecipientPermission -AccessRights SendAs -Trustee $RMUser -Confirm:$false

#Set Primary email address

Set-Mailbox Leah.granovskaya@colonyamerican.onmicrosoft.com -EmailAddress SMTP:Leah.granovskaya@colonyamericanfinance.com

#List what mailboxes user has access to

get-mailbox | get-mailboxpermission -User "Melissa Ferris" | fl identity

#With sizes
get-mailbox | get-mailboxpermission -User "Stephanie Campbell" | Get-MailboxStatistics | FT Displayname, totalitemsize -AutoSize

# Bulk add users to mail group
$AMembers = "Victoria Greene",	"Terry Piard",	"Nicole Donowick"

foreach ($AMember in $Amembers)
{
Add-DistributionGroupMember "Property Management – HOA Distribution List" -Member $AMember -BypassSecurityGroupManagerCheck
}