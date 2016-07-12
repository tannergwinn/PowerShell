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

#Dump Data

Get-ADUser -Filter * -Properties Displayname, Title, EmployeeID, Office, Officephone, MobilePhone, userprincipalname  -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" | 
    Select-Object Displayname, Title, EmployeeID, Office, Officephone, MobilePhone, userprincipalname, @{Name='Manager';Expression={(get-aduser (get-aduser $_ -Properties manager).manager).name}} | 
        Export-Csv C:\ScriptOutput\ADPull5$((Get-Date).ToString('MM-dd-yyyy')).csv
