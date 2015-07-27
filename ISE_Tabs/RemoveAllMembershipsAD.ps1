#Remove from all AD groups

$users= Import-Csv C:\ScriptsOutput\TestUsers.csv | foreach {Get-ADUser -Filter "SamAccountName -eq '$($_.SAMAccountName)'"} #get-aduser -Filter * -SearchBase "ou=ExEmployees,dc=contoso,dc=com"

Function RemoveMemberships

{

param([string]$SAMAccountName) 

$user = Get-ADUser $SAMAccountName -properties memberof

$userGroups = $user.memberof

$userGroups | %{get-adgroup $_ | Remove-ADGroupMember -confirm:$false -member $SAMAccountName}

$userGroups = $null

}


$users | %{RemoveMemberships $_.SAMAccountName}