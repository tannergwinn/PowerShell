Import-Module ActiveDirectory
 
$users = Get-ADUser -filter 'enabled -eq $true' -Properties SamAccountName -SearchBase "OU=CRM,DC=colonyah,DC=local"  #import-csv "c:\Scriptsources\CRMusers.csv"

foreach ($user in $users)

{
Get-ADUser $user.samaccountname | Set-ADAccountControl -PasswordNeverExpires $false$TargetUser = Get-ADUser -Filter {sAMAccountName -eq $user.samaccountname}$uObj = [ADSI]"LDAP://$TargetUser"$uObj.put("pwdLastSet", 0)$uObj.SetInfo()$uObj.put("pwdLastSet", -1)$uObj.SetInfo()
}


Get-ADUser -filter 'enabled -eq $true' -Properties SamAccountName -SearchBase "OU=CRM,DC=colonyah,DC=local" | Export-Csv C:\ScriptSources\CRMUsers.csv





{
Set-ADUser -identity "$($user.samaccountname)" -ChangePasswordAtLogon $true -Verbose
Set-ADUser -identity "$($user.samaccountname)" -ChangePasswordAtLogon $false -Verbose
}




{
Get-ADUser -Filter {sAMAccountName - 'coloninc'}
$uObj = [ADSI]"LDAP://$user"
$uObj.put("pwdLastSet", 0)
$uObj.SetInfo()
$uObj.put("pwdLastSet", -1)
$uObj.SetInfo()
}




