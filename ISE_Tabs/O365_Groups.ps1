# Connect to EXO
$creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://outlook.office365.com/powershell-liveid/  `
    -Credential $creds -Authentication Basic -AllowRedirection
Import-PSSession $Session
 
# Check status create OWA groups
Get-OwaMailboxPolicy | fl name, GroupCreationEnabled

#Disable Mobile User / OwaMailboxPolicy-Default

Set-OwaMailboxPolicy -Identity "Mobile Users" -GroupCreationEnabled $false

#Get Group information and export
$CRMGroups = Get-ADGroup -Filter * -SearchBase "OU=Affiliates,OU=CRM,DC=colonyah,DC=local"
foreach ($C in $CRMGroups)

{Get-MsolGroup -SearchString $C.name | Select-Object DisplayName, ObjectID | Export-Csv C:\Scriptsoutput\CRMGroups.csv -append}
 

#O365 Groups

#Set Primary SMTP
Set-unifiedgroup -Identity "Debt Management" -Primarysmtpaddress Debt@colonystarwood.com 


#Get Group objectID

Get-MsolGroup -SearchString "CAH maintenance"

#pull info on group -need group ID see above

Get-MsolGroupMember -groupObjectid 'b5a0ef9b-ebe6-41e9-8df5-8d8446b5039d' #| Select-Object DisplayName, EmailAddress | Export-Csv C:\ScriptsOutput\CAH_Employees.csv

#remove MSOLGroup

Remove-MsolGroup -ObjectId '1b93a62a-101e-4117-8fce-a632ded1b300' -Force

#Dynamic email Groups

New-DynamicDistributionGroup -Name "Regional Managers" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Title -like 'Regional Manager')}

New-DynamicDistributionGroup -Name "Scottsdale Office" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Office -like 'Scottsdale')}

#get members of Dynamic Group
$DDG = Get-DynamicDistributionGroup -Filter *
Get-Recipient -RecipientPreviewFilter $DDG.RecipientFilter | FT DisplayName


#Display group members
Get-DistributionGroupMember "CAH Scottsdale" |Select-Object Name #| measure

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


#Add user to multiple distribution lists

$Array = "DL 01","DL 03","DL 03" ForEach ($item in $Array) { Add-DistributionGroupMember -Identity $item –Member John –BypassSecurityGroupManagerCheck }

##Change Groups Manager
Remove-DistributionGroup <NameofGroup> -BypassSecurityGroupManagerCheck

Set-DistributionGroup Tenant_Sysadmins -ManagedBy Ariel.hart@colonyamerican.com -BypassSecurityGroupManagerCheck

Set-MsolUserPrincipalName -ObjectId aa014588-4100-4199-934c-43fb3e2998ca -NewUserPrincipalName CAHMaintenance@Colonyamerican.com



