Import-Module ActiveDirectory
 
$users = get-content "C:\Temp\Users.csv"
 
foreach ($user in $users)
{Get-ADUser $user | Set-ADAccountControl -PasswordNeverExpires $false
$TargetUser = Get-ADUser -Filter {sAMAccountName -eq $user}
$uObj = [ADSI]"LDAP://$TargetUser"
$uObj.put("pwdLastSet", 0)
$uObj.SetInfo()
$uObj.put("pwdLastSet", -1)
$uObj.SetInfo()}