Break
#ADGroups

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





