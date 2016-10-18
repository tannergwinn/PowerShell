#Remove from all AD groups

$users= get-aduser -filter 'enabled -eq $false' -Properties SamAccountName, UserPrincipalName -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local"

Function RemoveMemberships

{

param([string]$SAMAccountName) 

$user = Get-ADUser $SAMAccountName -properties memberof

$userGroups = $user.memberof

$userGroups | %{get-adgroup $_ | Remove-ADGroupMember -confirm:$false -member $SAMAccountName}

$userGroups = $null

}


$users | %{RemoveMemberships $_.SAMAccountName}