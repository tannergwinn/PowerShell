Import-Module ActiveDirectory            
      
$users = Import-Csv -Path C:\ScriptSources\AD_Update0215.csv       
    
            
foreach ($user in $users) 

{   

$Manager = (get-aduser -filter "Userprincipalname -eq '$($user.Manager)'")
         
Get-ADUser -Filter "Userprincipalname -eq '$($user.Upn)'" -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" | Set-ADUser -Title $($user.Title) -Manager $Manager -EmployeeID $($user.EmployeeID) -MobilePhone
}


-Company "Colony Starwood"  -Office $($user.Office)  -StreetAddress $($user.Address)




$users = Import-Csv -Path C:\ScriptSources\smart_Search_Results.csv     
    
            
foreach ($user in $users) 

{   

$SAM = $User.'Username'
         
Get-ADUser $SAM | Set-ADUser -MobilePhone $($user.CellNumber)
}


Get-ADUser -Filter * -Properties Displayname, Title, EmployeeID, Office, Officephone, MobilePhone, userprincipalname, Manager -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" | Select-Object Displayname, Title, EmployeeID, Office, Officephone, MobilePhone, userprincipalname, Manager | Export-Csv C:\ScriptsOutput\ADPull0215.csv
