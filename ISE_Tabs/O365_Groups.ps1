# Connect to EXO
$creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://outlook.office365.com/powershell-liveid/  `
    -Credential $creds -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Connect Msol
$msolcred = get-credential
connect-msolservice -credential $msolcred
 
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

Get-MsolGroup -SearchString "CAH_CRM_Users"

#pull info on group -need group ID see above

Get-MsolGroupMember -groupObjectid '0ee029e5-6ccc-4bd9-a775-8cb3cd71fece' -ManagedBy| FL #| Select-Object DisplayName, EmailAddress | Export-Csv C:\ScriptsOutput\CAH_Employees.csv


Get-MsolGroup -ObjectId '0ee029e5-6ccc-4bd9-a775-8cb3cd71fece' -ManagedBy

Get-DistributionGroup Finance@colonystarwood.com | FL

Set-DistributionGroup  
Set-DistributionGroup -Identity "Finance@colonystarwood.com" -MemberJoinRestriction Open -BypassSecurityGroupManagerCheck



Set-DistributionGroup -Identity "Finance@colonystarwood.com" -ManagedBy Ariel.Hart@colonystarwood.com -BypassSecurityGroupManagerCheck
 
#remove MSOLGroup

Remove-MsolGroup -ObjectId '83b1a09b-5eee-4ce2-b2fc-46c95e575332' -Force

#Dynamic email Groups

New-DynamicDistributionGroup -Name "Regional Managers" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Title -like 'Regional Manager')}

New-DynamicDistributionGroup -Name "Scottsdale Office" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Office -like 'Scottsdale')}

#get members of Dynamic Group
$DDG = Get-DynamicDistributionGroup -Filter *
Get-Recipient -RecipientPreviewFilter $DDG.RecipientFilter | FT DisplayName


#Display group members
Get-DistributionGroupMember "CAH Scottsdale" |Select-Object Name #| measure

Get-dis

#bulk add users to group 

$members = Import-Csv C:\ScriptOutput\AcqDailyPropDetail.csv

Foreach ($member in $members)

{
Add-distributiongroupmember -identity "Acq Daily Prop Detail" -Member $member.userprincipalname
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

#Get all groups a user is a member of

$Mailbox= get-Mailbox John.Price@colonystarwood.com
$DN=$mailbox.DistinguishedName
$Filter = "Members -like ""$DN"""
Get-DistributionGroup -ResultSize Unlimited -Filter $Filter | Select-Object Name, PrimarySmtpAddress | Export-Csv C:\ScriptOutput\"$Mailbox"O365Groups_$((Get-Date).ToString('MM-dd-yyyy')).csv

#Remove all groups from a user

$Mailbox=get-Mailbox Johnathan.sorisho@colonystarwood.com
$DN=$mailbox.DistinguishedName
$Filter = "Members -like ""$DN"""
Get-DistributionGroup -ResultSize Unlimited -Filter $Filter | Remove-distributiongroupmember



