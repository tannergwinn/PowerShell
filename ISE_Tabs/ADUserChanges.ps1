#Updating employees

#Single user change

##Enter SamNames for Manager and Employee - Variables are equal to PS params

$Manager = "W.Campbell"
$Office = "Lilburn"
$Title = "CSR - Service"
$Employee = 'm.williams'

Get-aduser $Employee| Set-ADUser -Manager $Manager -Confirm



#Bulk change users attributes - SAMAccountname required

Import-Module ActiveDirectory            
                
$users = Import-Csv -Path C:\ScriptSources\SAMName224.csv                      
        
foreach ($user in $users)

{            
Get-ADUser -Filter "SamAccountName -eq '$($user.SAMAccountName)'" -Properties Title, Department -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" |
    Set-ADUser -Title "$($user.Title)" -Department "$($user.Department)" -Office "$($user.Office)" -Manager "$($User.Manager)"  -verbose -PassThru -EA stop
}