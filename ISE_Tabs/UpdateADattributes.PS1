Import-Module ActiveDirectory            
      
$users = Import-Csv -Path C:\temp\UpdateADAttributes.csv            
    
            
foreach ($user in $users) 

{            
Get-ADUser -Filter "SamAccountName -eq '$($user.samaccountname)'" -Properties * -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" 
 |            
  Set-ADUser -MobilePhone $($user.MobilePhone) -OfficePhone $($user.OfficePhone)
}
