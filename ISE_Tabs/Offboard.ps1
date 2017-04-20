﻿
## This will remove the groups and
## remove the licenses / delete the user in O365 / Move to disabled OU 
## for DISABLED USERS in CAH_MailBox_Backup OU
########################################################################

#############
#Connect Msol
#############

$msolcred = get-credential
connect-msolservice -credential $msolcred
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $msolcred -Authentication Basic -AllowRedirection
Import-PSSession $Session

####################################################
#Remove AD Group Membership from Offboarded Accounts
####################################################

$users= get-aduser -filter 'enabled -eq $false' -Properties SamAccountName, UserPrincipalName -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local"

Function RemoveMemberships

{
param([string]$SAMAccountName) 
$user = Get-ADUser $SAMAccountName -properties memberof
$userGroups = $user.memberof
$userGroups | %{get-adgroup $_ | Remove-ADGroupMember -confirm:$false -member $SAMAccountName}
$userGroups = $null
} $users | %{RemoveMemberships $_.SAMAccountName}


####################
#Move to disabled OU
####################

$Moved = Get-ADUser -filter 'enabled -eq $false' -Properties SamAccountName, UserPrincipalName -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local"
foreach ($M in $Moved)
{
Get-ADUser $M | Move-ADObject -TargetPath "OU=CAH_Disabled,DC=colonyah,DC=local"
}

###############################
#Measure Users left to offboard
###############################

Get-ADUser -filter 'enabled -eq $true'  -Properties * -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local" | Measure | Select-Object Count |FL

##############################################
#Get the Users who are offboarded send to file
##############################################

Get-ADUser -filter 'enabled -eq $true'  -Properties Userprincipalname -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local" | 
    Select-object @{n="SourceMailbox"; e= {$_.Userprincipalname}}, @{n='ExportDirectory';e={"C:\PSTFiles"}}, @{n='ExportMailbox';e={"TRUE"}}, @{n='ExportArchive';e={"TRUE"}}, @{n='ExportDumpster';e={"TRUE"}}|
    Export-csv -path c:\ScriptOutput\OffboardList_$((Get-Date).ToString('MM-dd-yyyy')).csv 



########################
#Set users hide from GAL
########################

Get-ADUser -filter * -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local" | Set-ADObject -replace @{msExchHideFromAddressLists=$true}

################################################
#Measure outstanding mailboxes - Litigation Hold
################################################ 

Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize unlimited -Filter 'LitigationHoldEnabled -eq $false' | Measure

#####################################
#Set Litigation Hold and Admin rights
#####################################

Get-Mailbox -ResultSize Unlimited -Filter 'LitigationHoldEnabled -eq $false' | Add-MailboxPermission -User Tenant_SysAdmins -AccessRights FullAccess | Add-RecipientPermission -AccessRights SendAs -Trustee Tenant_SysAdmins -Confirm:$false | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration 2555

-RecipientTypeDetails UserMailbox

#####################################
#Set Litigation Hold on new mailboxes
#####################################

Get-Mailbox -ResultSize unlimited -Filter 'LitigationHoldEnabled -eq $false' | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration 2555

-RecipientTypeDetails UserMailbox
#####################################
#Set Litigation Hold on all mailboxes
#####################################

Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox"} | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration 2555



###########################################
#Remove records from O365
#** No longer needed when Offboarding - Changes in Centrify
###########################################

$offboard = Get-ADUser -filter 'enabled -eq $false' -Properties SamAccountName, UserPrincipalName -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local"

foreach ($O in $Offboard)

{
#Get-MsolUser -UserPrincipalName $o.UserPrincipalName 
Remove-MsolUser -UserPrincipalName $o.UserPrincipalName -Force
}







$users= get-aduser -filter 'enabled -eq $True' -Properties SamAccountName, UserPrincipalName -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local"

Function RemoveMemberships

{
param([string]$SAMAccountName) 
$user = Get-ADUser $SAMAccountName -properties memberof
$userGroups = $user.memberof
$userGroups | %{get-adgroup $_ | Remove-ADGroupMember -confirm:$false -member $SAMAccountName}
$userGroups = $null
} $users | %{RemoveMemberships $_.SAMAccountName}



foreach ($user in $users) 

{

Add-ADGroupMember -Identity "O365_E3" -Members $user.Samaccountname

} 