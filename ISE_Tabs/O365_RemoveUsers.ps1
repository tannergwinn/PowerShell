#Removing O365 Users

#Removing single users from O365 (license already removed)

$User = "OpenEscrow@colonyamerican.com"
    Get-MsolUser -UserPrincipalName $User
    #Set-MsolUserLicense -UserPrincipalName $user -RemoveLicenses Colonyamerican:StandardPACK, Colonyamerican:CRMSTANDARD
    Remove-MsolUser -UserPrincipalName $User -Force
    #Remove-MsolUser -UserPrincipalName $User -RemoveFromRecyclebin -Force

#Batch users from O365 -License already removed (Uses email address)

$users = get-content "C:\ScriptSources\RemoveFromO365.csv"
foreach ($user in $users)
{
Get-MsolUser -UserPrincipalName $user
Remove-MsolUser -UserPrincipalName $user
}

#Single / individual user removal from 0365 with license -Removes from RecycleBin

$user = Read-Host "Enter email"

Get-MsolUser -UserPrincipalName $user
    Set-MsolUserLicense -UserPrincipalName $user -RemoveLicenses Colonyamerican:STANDARDPACK
    Remove-MsolUser -UserPrincipalName $user -Force
    Remove-MsolUser -UserPrincipalName $user -RemoveFromRecyclebin

#Remove all users from recyle bin 

Get-MsolUser -all -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin -Force