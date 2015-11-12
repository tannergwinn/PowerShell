#Updating employees

#Single user change

#Generate SAM Name in excel =CONCATENATE(LEFT(C2,1)&".", B2)


##Enter SamNames for Manager and Employee - Variables are equal to PS params

#$Department = "Technology"
$Office = "Stockbridge"
$Manager = "V.Norkum"
$Title = "Customer Service Representative"
$Employee = 'T.Quick'

Get-aduser $Employee |
 Set-ADUser -Manager $Manager -Title $Title -Office $Office -Confirm 



#Bulk change users attributes - SAMAccountname required

Import-Module ActiveDirectory            
                
$users = Import-Csv -Path C:\ScriptSources\SAMName224.csv                      
        
foreach ($user in $users)

{            
Get-ADUser -Filter "SamAccountName -eq '$($user.SAMAccountName)'" -Properties Title, Department -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" |
    Set-ADUser -Title "$($user.Title)" -Department "$($user.Department)" -Office "$($user.Office)" -Manager "$($User.Manager)"  -verbose -PassThru -EA stop
}