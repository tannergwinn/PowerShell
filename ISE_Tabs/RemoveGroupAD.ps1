Break

#Bulk remove group members from AD Group (uses logon name)

$users = Import-CSV "c:\ScriptSources\Offboard.csv"

Foreach ($user in $users)

{
  Get-aduser  -Filter "SamAccountName -eq '$($user.SAMAccountName)'" -Properties * -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local" |
    Remove-ADPrincipalGroupMembership -MemberOf "O365_Users" -Confirm:$false
}



remove-adgroupmember -Identity "O365_Users"