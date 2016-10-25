## This will remove the groups and
## remove the licenses / delete the user in O365 / Move to disabled OU 
## for DISABLED USERS in CAH_MailBox_Backup OU
########################################################################

#Connect Msol
$msolcred = get-credential
connect-msolservice -credential $msolcred
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $msolcred -Authentication Basic -AllowRedirection
Import-PSSession $Session
#Remove AD Group Membership from Offboarded Accounts
$users= get-aduser -filter 'enabled -eq $false' -Properties SamAccountName, UserPrincipalName -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local"
Function RemoveMemberships
{
param([string]$SAMAccountName) 
$user = Get-ADUser $SAMAccountName -properties memberof
$userGroups = $user.memberof
$userGroups | %{get-adgroup $_ | Remove-ADGroupMember -confirm:$false -member $SAMAccountName}
$userGroups = $null
} $users | %{RemoveMemberships $_.SAMAccountName}
#Remove from O365
$offboard = Get-ADUser -filter 'enabled -eq $false' -Properties SamAccountName, UserPrincipalName -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local"
foreach ($O in $Offboard)
{
#Get-MsolUser -UserPrincipalName $o.UserPrincipalName 
Remove-MsolUser -UserPrincipalName $o.UserPrincipalName -Force
}
#Move to disabled
$Moved = Get-ADUser -filter 'enabled -eq $false' -Properties SamAccountName, UserPrincipalName -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local"
foreach ($M in $Moved)
{
Get-ADUser $M | Move-ADObject -TargetPath "OU=CAH_Disabled,DC=colonyah,DC=local"
}

#Measure Users left to offboard

Get-ADUser -filter 'enabled -eq $true'  -Properties * -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local" | Measure 

#Get the Users who are offboarded send to file

Get-ADUser -filter 'enabled -eq $true'  -Properties * -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local" |Select-object Userprincipalname | Export-csv -path c:\ScriptOutput\OffboardList_$((Get-Date).ToString('MM-dd-yyyy')).csv 

#Set users hide from GAL
Get-ADUser -filter * -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local" | Set-ADObject -replace @{msExchHideFromAddressLists=$true}

#Measure outstanding mailboxes - Litigation Hold
Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize unlimited -Filter 'LitigationHoldEnabled -eq $false' | Measure

Get-Mailbox -ResultSize Unlimited -Filter 'LitigationHoldEnabled -eq $false' | Add-MailboxPermission -User Tenant_SysAdmins -AccessRights FullAccess | Add-RecipientPermission -AccessRights SendAs -Trustee Tenant_SysAdmins -Confirm:$false


#Set Litigation Hold on new mailboxes

Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize unlimited -Filter 'LitigationHoldEnabled -eq $false' | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration 2555

#Set Litigation Hold on all mailboxes
Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox"} | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration 2555


