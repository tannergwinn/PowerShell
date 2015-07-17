Import-Module ActiveDirectory            
                
$users = Import-Csv -Path C:\ScriptSources\SAMName224.csv                      

        
foreach ($user in $users)

{            
Get-ADUser -Filter "SamAccountName -eq '$($user.SAMAccountName)'" -Properties Title, Department -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" |
    Set-ADUser -Title "$($user.Title)" -Department "$($user.Department)" -Office "$($user.Office)" -Manager "$($User.Manager)"  -verbose -PassThru -EA stop
}