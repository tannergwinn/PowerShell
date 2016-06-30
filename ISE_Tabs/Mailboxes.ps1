#Add rights to a mailbox

$MBX = Import-Csv C:\ScriptOutput\CSHRooms.csv  
$MUser = "Mail" 

Get-Mailbox $MBX |
    Add-MailboxPermission -User $MUser -AccessRights FullAccess -InheritanceType All |
    Add-RecipientPermission -AccessRights SendAs -Trustee $MUser -Confirm:$false

#Remove rights to a mailbox
$RMBX = "Atlanta North Central District" 
$RMUser = "Candice Byndloss"

    Remove-MailboxPermission -Identity $RMBX -User $RMUser -AccessRights FullAccess -InheritanceType All -Confirm:$false |
    Remove-RecipientPermission -AccessRights SendAs -Trustee $RMUser -Confirm:$false

#geAdd the ADmins
Get-Mailbox -ResultSize Unlimited | Add-MailboxPermission -User Tenant_SysAdmins -AccessRights FullAccess | Add-RecipientPermission -AccessRights SendAs -Trustee Tenant_SysAdmins -Confirm:$false

#Set Primary email address

$Ename = "Katieday"
$OldUPN = "$Ename@colonystarwood.com"
$TempUPN = "$Ename@colonyamerican.onmicrosoft.com"
$NewUPN = "$ename@colonystarwood.com"

Set-Mailbox $OldUPN -EmailAddress "SMTP:$TempUMP" | Set-Mailbox $TempUPN -EmailAddress "SMTP:$NewUPN"

#Set UPN
Set-MsolUserPrincipalName -UserPrincipalName "$OldUPN" -NewUserPrincipalName $TempUPN 
 
Set-MsolUserPrincipalName -UserPrincipalName $TempUPN -NewUserPrincipalName $NewUPN


Set-MsolUserPrincipalName -UserPrincipalName danas@colonystarwood.com -NewUserPrincipalName Danas@colonyamerican.onmicrosoft.com



#List what mailboxes user has access to

get-mailbox -ResultSize Unlimited | get-mailboxpermission -User "Aubrey Hall" | fl identity
#With sizes
get-mailbox -ResultSize Unlimited | get-mailboxpermission -User "Candice Byndloss" | Get-MailboxStatistics | FT Displayname, totalitemsize -AutoSize


#Calendar Permissions for 1 user
ForEach ($mbx in Get-Mailbox) {Get-MailboxFolderPermission ($mbx.Name + ":\Calendar") | Where-Object {$_.User -like 'Ariel Hart'} | Select Identity,User,AccessRights}

#Calendar for all users in enviroment
ForEach ($mbx in Get-Mailbox) {Get-MailboxFolderPermission ($mbx.Name + “:Calendar”) | Select Identity,User,AccessRights | ft -Wrap -AutoSize}


# Bulk add users to Distribution group
$AMembers = "Victoria Greene",	"Terry Piard",	"Nicole Donowick"

foreach ($AMember in $Amembers)
{
Add-DistributionGroupMember "Property Management – HOA Distribution List" -Member $AMember -BypassSecurityGroupManagerCheck
}


#Bulk add users to Mailbox

$smbUs = "Kris Norden"			


foreach ($smbU in $smbUs)

{Get-Mailbox Tucsonleasing@colonystarwood.com |
    Add-MailboxPermission -User $smbU -AccessRights FullAccess -InheritanceType All |
    Add-RecipientPermission -AccessRights SendAs -Trustee $smbU -Confirm:$false
    }



#mailbox quota

Get-mailbox insurance@colonyamerican.com | Set-Mailbox -ProhibitSendReceiveQuota 10GB -ProhibitSendQuota 9.75GB -IssueWarningQuota 9.5GB


#list the mailboxes with Properties
Get-Mailbox -ResultSize Unlimited | Select-Object samaccountname, PrimarySmtpAddress, WhenCreated, RecipientTypeDetails | Export-csv C:\ScriptsOutput\MailboxesAll0106.csv


#Remove Mailboxes

Get-Mailbox freddiemac@vineyardservices.com | Remove-Mailbox 

Set-Mailbox CAHMaintenance@Colonyamerican.onmicrosoft.com -Emailaddress CAHMaintenance@Colonyamerican.com

#Clutter
<<<<<<< HEAD
=======
Get-mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited | Set-Clutter -Enable $false

>>>>>>> origin/master
Get-mailbox -ResultSize Unlimited | Set-Clutter -Enable $false

$Clutterers = import-csv "C:\users\a.hart\ClutterDetails.csv"

foreach ($Clutter in $Clutterers)

{
Get-Mailbox $Clutter.Userprincipalname | Set-Clutter -Enable $false

}

#Get Size of AD users Mailbox
Get-ADUser -Filter * -Properties * -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local" |Select-Object Userprincipalname, displayname | Export-Csv C:\ScriptOutput\MailSizes.csv

$Offers = Import-Csv C:\ScriptOutput\MailSizes.csv
foreach ($O in $Offers)
{

Get-mailbox $O.Userprincipalname | Get-MailboxStatistics | Select-Object Displayname, totalitemsize | Export-Csv C:\ScriptOutput\MailSizesO365.csv -Append
}

#Add Many Mailboxes to a user

$MBXS = Import-Csv C:\ScriptOutput\CSHRooms.csv
$MBUser = "Melissa Ferris"

foreach ($MBX in $MBXS)
{

Get-Mailbox $MBX.Alias |
    Add-MailboxPermission -User $MUser -AccessRights FullAccess -InheritanceType All
    # |Add-RecipientPermission -AccessRights SendAs -Trustee $MUser -Confirm:$false
}


##Bulk remove mailbox permissions

$RMBXS = Import-Csv C:\ScriptOutput\CSHRooms.csv
$RMBUser = "Melissa Ferris"

foreach ($RMBX in $RMBXS)
{

Get-mailbox -Identity $RMBX.alias | Remove-MailboxPermission  -User $RMBUser -AccessRights FullAccess -InheritanceType All -Confirm:$false |
    Remove-RecipientPermission -AccessRights SendAs -Trustee $RMBUser -Confirm:$false
}

#Soft deleted mailboxes

Get-Mailbox -SoftDeletedMailbox -Identity user@domain.com |fl *guid
Remove-Mailbox -Identity 8f1f3498-cc94-4c86-9b30-3293cb3cacb2 -PermanentlyDelete

