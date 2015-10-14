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

#Removing single users from O365 (license already removed)

$User = "Nic.Walling@colonyamericanfinance.com"
    #Get-MsolUser -UserPrincipalName $User
    #Set-MsolUserLicense -UserPrincipalName $user -RemoveLicenses Colonyamerican:STANDARDPACK
    #Remove-MsolUser -UserPrincipalName $User -Force
    Remove-MsolUser -UserPrincipalName $User -RemoveFromRecyclebin -Force

#Batch remove licesnses and users from O365 (Uses email address)

$users = Import-Csv "C:\ScriptsOutput\DisabledAD.csv"

foreach ($user in $users)
{
Get-MsolUser -UserPrincipalName $user.UserPrincipalName
    Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -RemoveLicenses Colonyamerican:STANDARDPACK
    Remove-MsolUser -UserPrincipalName $user.UserPrincipalName -Confirm:$false
} 

#Batch users from O365 -License already removed (Uses email address)

$users = get-content "C:\ScriptSources\RemoveFromO365.csv"
foreach ($user in $users)
{
Get-MsolUser -UserPrincipalName $user
Remove-MsolUser -UserPrincipalName $user
}

#Remove contact




##O365 Account license information 


#Pull Licenses
$AccountSku = Get-MsolAccountSku

#Count how many
$AccountSku.Count

#Pull data on each (1 line for each license)
$AccountSku[0].AccountSkuId
$AccountSku[1].AccountSkuId
$AccountSku[2].AccountSkuId
$AccountSku[3].AccountSkuId
$AccountSku[4].AccountSkuId
$AccountSku[5].AccountSkuId


#For Each user loop to pull license data
$licensedetails = (Get-MsolUser -UserPrincipalName `
  "Ariel.Hart@colonyamerican.com").Licenses
$licensedetails.Count;
# If there's a license, show the details.
# Otherwise, the output is blank.
if ($licensedetails.Count -gt 0){
  foreach ($i in $licensedetails){
    $i.ServiceStatus
  }
}

#Pull list of unlicensed O365 Users

Get-MsolUser -All | 
Select-Object UserPrincipalName, DisplayName, isLicensed |
    Export-Csv C:\Temp\UnlicensesedToRemove.csv

  $userLicenseTest = Get-MsolUser `
  -UserPrincipalName "Aiden.Hong@colonyamerican.com"

  $userLicenseTest.IsLicensed


#O365 manipulations


#Calendar

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

Set-Mailbox Leah.granovskaya@colonyamerican.onmicrosoft.com -EmailAddress SMTP:Leah.granovskaya@colonyamericanfinance.com

#Calendar Manipulation

Calendar permissions-
add-MailboxFolderPermission -Identity brad.hull@colonyamerican.com:\Calendar -User Melissa.Ferris@colonyamerican.com -AccessRights PublishingAuthor

##Access Levels-
##Owner PublishingEditor, Editor, PublishingAuthor, Author, NonEditingAuthor, Reviewer, Contributor, AvailabilityOnly, LimitedDetails

Remove-MailboxFolderPermission -Identity user@mycompany:\calendar -user myuser@mycompany.com

#View Permissions-
Get-MailboxFolderPermission –Identity Jennifer.stewart@colonyamerican.com:\calendar

#Single / individual user removal from 0365 with license -Removes from RecycleBin


$user = Read-Host "Enter email"

Get-MsolUser -UserPrincipalName $user
    Set-MsolUserLicense -UserPrincipalName $user -RemoveLicenses Colonyamerican:STANDARDPACK
    Remove-MsolUser -UserPrincipalName $user -Force
    Remove-MsolUser -UserPrincipalName $user -RemoveFromRecyclebin


#Get alias list
Get-Mailbox "CAH_Social" | Select-Object Displayname,@{Name=“EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_ -LIKE “SMTP:*”}}} | Sort |  Export-Csv C:\ScriptsOutput\SocialEmail.csv


#Get Group objectID

Get-MsolGroup -SearchString "CAH Scottsdale"

#pull info on group -need group ID see above

Get-MsolGroupMember -groupObjectid 'b5a0ef9b-ebe6-41e9-8df5-8d8446b5039d' | Select-Object DisplayName, EmailAddress | Export-Csv C:\ScriptsOutput\CAH_Employees.csv

#remove MSOLGroup

Remove-MsolGroup -ObjectId '' -Force

#Dynamic email Groups

New-DynamicDistributionGroup -Name "Regional Managers" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Title -like 'Regional Manager')}


New-DynamicDistributionGroup -Name "Scottsdale Office" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Office -like 'Scottsdale')}

#get members of Dynamic Group
$DDG = Get-DynamicDistributionGroup -Filter *
Get-Recipient -RecipientPreviewFilter $DDG.RecipientFilter | FT DisplayName


#Display group members
Get-DistributionGroupMember "CAH Scottsdale" | measure

#bulk add users to group 

$members = Import-Csv C:\ScriptsOutput\CAH_Employees.csv

Foreach ($member in $members)

{
Add-distributiongroupmember -identity "CAH" -Member $member.userprincipalname
}


#Bulk remove users from group

$Rmembers = Import-Csv C:\ScriptsOutput\CAH_Employees.csv

Foreach ($Rmember in $Rmembers)

{
Remove-distributiongroupmember -identity "CAH" -Member $Rmember.userprincipalname -Confirm:$false
}

# Remove group
Remove-DistributionGroup "CAH Scottsdale" -Confirm:$false

#bulk Add users to O365 group from AD group

$groups = Get-ADGroupMember CAH_Employees | Get-ADUser -Properties UserPrincipalName | Select-Object UserPrincipalName

ForEach ($group in $groups)

{
Add-distributiongroupmember -identity "CAH" -Member $group.UserPrincipalName
}


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

#Add user to multiple distribution lists

$Array = "DL 01","DL 03","DL 03" ForEach ($item in $Array) { Add-DistributionGroupMember -Identity $item –Member John –BypassSecurityGroupManagerCheck }
