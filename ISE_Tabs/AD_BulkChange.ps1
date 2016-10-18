#Change users Title and Department from CSV Bulk

Import-Module ActiveDirectory            
                
$users = Import-Csv -Path C:\ScriptSources\SAMName3.csv                      
            
$output = foreach ($user in $users)

{            
Get-ADUser -Filter "SamAccountName -eq '$($user.SAMAccountName)'" -Properties * -SearchBase "OU=CAH_Users,DC=Colonyah,DC=local" |
    Set-ADUser -Title "$($user.Title)" -Department "$($user.Department)" -OfficePhone "$($user.CellNumber)" -Manager (Gat-aduser -filter $user.mangerassociateID)
} $output | Out-File C:\ScriptsOutput\errors.txt -append
 

Get-ADUser -Filter 'enabled -eq $true' -Properties DisplayName, SAMAccountName | Select-Object DisplayName, SAMAccountName | Export-Csv C:\ScriptSources\SAMName2.csv

Start-Transcript -path c:\docs\Text3.txt


Import-Module ActiveDirectory            
                
$users = Import-Csv -Path C:\ScriptSources\SAMName3.csv                      

foreach ($user in $users)

{            
Get-ADUser -Filter "SamAccountName -eq '$($user.SAMAccountName)'" -Properties * -SearchBase "DC=Colonyah,DC=local" |
    Set-ADUser -Title "$($user.Title)" -Department "$($user.Department)" -verbose -PassThru -EA stop
}


#Update Manager

$users = Import-Csv -Path C:\ScriptSources\ADP_Changes062016.csv                   
            
$output = foreach ($user in $users)

{            
Get-ADUser -Filter "EmployeeID -eq '$($user.EmployeeID)'" -Properties * -SearchBase "OU=CAH_Users,DC=Colonyah,DC=local" |
    Set-ADUser  -Manager (Get-aduser -filter "EmployeeID -eq '$($user.ManagerID)'")
} $output | Out-File C:\ScriptsOutput\errorsADP0620.txt -append

#Single instance

Get-ADUser -Filter "EmployeeID -eq 'HZ9V61TUL'" -Properties * -SearchBase "OU=CAH_Users,DC=Colonyah,DC=local" |
    Set-ADUser  -Manager (Get-aduser -filter "EmployeeID -eq '$($user.ManagerID)'")

## Report to HR

Get-ADUser -Filter * -Properties Displayname, Title, Department, Manager, OfficePhone, MobilePhone, Userprincipalname, Office, StreetAddress -SearchBase "OU=CAH_Users,DC=Colonyah,DC=local" | Select-Object Displayname, Title, Department, OfficePhone, MobilePhone, Userprincipalname, Office, StreetAddress, Manager |Export-Csv C:\ScriptOutput\AD_report_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv
