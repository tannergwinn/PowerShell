




# Bulk add to group with UPN
$users = Import-Csv C:\ScriptSources\CMP_Groups.csv

foreach ($user in $users) 

{
$UserUPN = $User.UserName

Add-ADGroupMember -Identity "CMP_Estimator" -Members (Get-ADUser -Filter {(UserPrincipalName -eq $userUPN) -and (Enabled -eq $true)})

} 

#Count to confirm

Get-ADGroupmember "CMP_Prod" | Measure 
