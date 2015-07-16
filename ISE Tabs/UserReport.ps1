Get-ADUser -Identity a.hart -Properties Title, Department | Select-Object Title, Department


Get-ADUser -filter  'enabled -eq $true'  -properties DisplayName, Department, mail, Office |
    sort-object DisplayName | select-object DisplayName, Department, mail, Office | Export-csv -path c:\ScriptsOutput\EmployeeList.csv

#Get Users SAM name for attribute changes vlookup

Get-ADUser -filter  'enabled -eq $true'  -properties DisplayName, sAMAccountName, Surname | sort-object DisplayName | select-object DisplayName, Surname, sAMAccountName | Export-csv -path C:\ScriptsOutput\SamAccount.csv

#Get members of Group

Get-ADGroupMember "CAH_Employees"  | select-object Name | Export-csv -path c:\ScriptsOutput\CAH_Users.csv

#Get members of group and group members (Users) properties

Get-ADGroupMember -identity "CAH_Employees" -recursive |
    Get-ADUser -Properties Displayname, mail | 
    Select-Object Displayname, mail | 
    Export-csv -path c:\ScriptsOutput\CAH_Users.csv

