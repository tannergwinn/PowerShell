#Pull password expired

Get-ADUser -filter  'enabled -eq $true'  -properties passwordlastset, passwordneverexpires, LastLogonDate, sAMAccountName, company  |
    select-object Name, passwordlastset, LastLogonDate, passwordneverexpires, sAMAccountName, company |
    Export-csv -path c:\ScriptsOutput\PswExpired2.csv

#use LogonTimestamp for Logon

Get-ADUser -filter  'enabled -eq $true'  -properties passwordlastset, passwordneverexpires, LastLogonTimestamp, sAMAccountName, company -SearchBase "OU=CAH_Users,DC=colonyah,DC=local"  |
    Select-object Name, passwordlastset, @{n='LastLogonTimestamp';e={[DateTime]::FromFileTime($_.LastLogonTimestamp)}}, passwordneverexpires, sAMAccountName, company |
    Export-csv -path c:\ScriptsOutput\PswExpired2.csv

#Just CRM
Get-ADUser -filter  'enabled -eq $true'  -properties passwordlastset, passwordneverexpires, LastLogonTimestamp, sAMAccountName, company -SearchBase "OU=CRM,DC=colonyah,DC=local"  |
    Select-object Name, passwordlastset, @{n='LastLogonTimestamp';e={[DateTime]::FromFileTime($_.LastLogonTimestamp)}}, passwordneverexpires, sAMAccountName, company |
    Export-csv -path c:\ScriptsOutput\PswExpiredCRM.csv