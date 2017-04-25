Break
#ADGroups


#Get group info and export
$CRMGroups = Get-ADGroup -Filter * -SearchBase "OU=Affiliates,OU=CRM,DC=colonyah,DC=local"
foreach ($C in $CRMGroups)


{Get-MsolGroup -SearchString $C.name | Select-Object DisplayName, ObjectID | Export-Csv C:\Scriptsoutput\CRMGroups.csv -append}


#Get members of a group

Get-ADGroupmember "O365_SkypeConferenceCalling" | Measure 

| select-Object name |Export-csv -path c:\ScriptOutput\FS-CompassReports_RO$((Get-Date).ToString('MM-dd-yyyy')).csv 

#Get All the groups members -with description
$ADGroups = Get-ADGroup -Filter * -SearchBase "OU=CAH_Groups,DC=colonyah,DC=local" -Properties Description
foreach ($ADG in $ADGroups)

{Get-ADGroupmember $ADG  | 
Select-Object Name, @{n='GroupName';e={$ADG.name}} , @{n='GroupDescription';e={(get-adgroup $ADG -properties description).Description}}, @{n='When User Created';e={((Get-ADUser $_ -Properties whencreated).whencreated)}} | 
Export-Csv C:\Scriptoutput\ADGroups$((Get-Date).ToString('MM-dd-yyyy')).csv -Append }

#Get CMP groups members

$ADGroups = Get-ADGroup -Filter {name -like "*CMP*"} -Properties Description
foreach ($ADG in $ADGroups)

{Get-ADGroupmember $ADG  | 
Select-Object Name, userprincipalname, @{n='Group Name';e={$ADG.name}} , @{n='Group Description';e={(get-adgroup $ADG -properties description).Description}} | 
Export-Csv C:\Scriptoutput\CMPRoles$((Get-Date).ToString('MM-dd-yyyy')).csv -Append }

#Get groups user is a member of- include nested
$username = 'J.Price'
$dn = (Get-ADUser $username).DistinguishedName
$Name = (Get-ADUser $username).Name
Get-ADGroup -LDAPFilter ("(member:1.2.840.113556.1.4.1941:={0})" -f $dn) | select Name, DistinguishedName | sort Name | Export-Csv C:\ScriptOutput\"$Name"ADGroups_$((Get-Date).ToString('MM-dd-yyyy')).csv

#Restric Sendto on AD Distro Group

set-adobject "CN=Atlas,OU=CAH_Groups,DC=colonyah,DC=local" -Add @{dLMemSubmitPerms="CN=Erika Yelenosky,OU=SDL-200,OU=CAH_Users,DC=colonyah,DC=local"}

#Show change in AD

Get-ADGroup Atlas -Properties * | Select Name, dLMemRejectPerms, dLMemSubmitPerms | FL

#or

get-adobject "CN=Atlas,OU=CAH_Groups,DC=colonyah,DC=local" -Properties * | Select dLMemSubmitPerms, whenchanged

#Confirm changes in O365

Get-DistributionGroup Atlas | select name, acceptMessagesOnlyFrom, AcceptMessagesOnlyFromDLMembers, AcceptMessagesOnlyFromSendersOrMembers, WhenChanged 



######TESTING######


Get-ADGroup Atlas -Properties * | Select Name, dLMemRejectPerms, @{Name='dLMemSubmitPerms';Expression={(get-aduser ($_.dLMemSubmitPerms).name).name}} | FL


$DLPerms = 


$GETADDLMEMs =  ((Get-ADGroup Atlas -Properties dLMemSubmitPerms).dLMemSubmitPerms) 

$Finallist = foreach ($GAM in $GETADDLMEMs)

{Get-ADUser "$GAM" | Select Name}

Get-ADUser "CN=Ariel Hart,OU=SDL-200,OU=CAH_Users,DC=colonyah,DC=local"





