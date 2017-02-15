#Enhanced user report

Get-ADUser -filter  'enabled -eq $true'  -properties passwordlastset, LastLogonTimestamp, sAMAccountName, Title, physicalDeliveryOfficeName, manager -SearchBase "OU=CAH_Users,DC=colonyah,DC=local"  |
    Select-object Name, Title, physicalDeliveryOfficeName, @{Name='Manager';Expression={(get-aduser (get-aduser $_ -Properties manager).manager).name}}, passwordlastset, @{n='LastLogonTimestamp';e={[DateTime]::FromFileTime($_.LastLogonTimestamp)}}, sAMAccountName |
    Export-csv -path c:\ScriptOutput\PswExpired_ExtendedProperties$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv

#user LogonTimestamp for Logon

Get-ADUser -filter  'enabled -eq $true'  -properties passwordlastset, passwordneverexpires, LastLogonTimestamp, sAMAccountName, company -SearchBase "OU=CAH_Users,DC=colonyah,DC=local"  |
    Select-object Name, passwordlastset, @{n='LastLogonTimestamp';e={[DateTime]::FromFileTime($_.LastLogonTimestamp)}}, passwordneverexpires, sAMAccountName, company |
    Export-csv -path c:\ScriptOutput\PswExpired2_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv


#Pull password expired

Get-ADUser -filter  'enabled -eq $true'  -properties passwordlastset, passwordneverexpires, LastLogonDate, sAMAccountName, company  |
    select-object Name, passwordlastset, LastLogonDate, passwordneverexpires, sAMAccountName, company |
    Export-csv -path c:\ScriptsOutput\PswExpired2.csv

#Just CRM

Get-ADUser -filter  'enabled -eq $true'  -properties passwordlastset, passwordneverexpires, LastLogonTimestamp, sAMAccountName, company -SearchBase "OU=CRM,DC=colonyah,DC=local"  |
    Select-object Name, passwordlastset, @{n='LastLogonTimestamp';e={[DateTime]::FromFileTime($_.LastLogonTimestamp)}}, passwordneverexpires, sAMAccountName, company |
    Export-csv -path c:\ScriptsOutput\PswExpiredCRM.csv


#DSX User Audit Report
Get-ADUser -filter  'enabled -eq $true'  -properties  sAMAccountName, Title, physicalDeliveryOfficeName, manager -SearchBase "OU=CAH_Users,DC=colonyah,DC=local"  |
    Select-object Name,@{n='DSX Name'; e={$_.Surname, $_.GivenName -join ", "}}, Title, physicalDeliveryOfficeName, @{Name='Manager';Expression={(get-aduser (get-aduser $_ -Properties manager).manager).name}} |
    Export-csv -path c:\ScriptOutput\AD_EmployeeListForDSX$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv