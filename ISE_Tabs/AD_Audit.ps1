
##Sox Audit
Get-ADUser -filter *  -properties passwordlastset, LastLogonTimestamp, Whencreated, DistinguishedName, Whenchanged  |
    Select-object Name, passwordlastset, @{n='LastLogonTimestamp';e={[DateTime]::FromFileTime($_.LastLogonTimestamp)}}, Whencreated, whenchanged, DistinguishedName |
    Export-csv -path c:\ScriptsOutput\ADAccess_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv


#Yardi User Audit

Get-ADUser -filter *  -properties GivenName, Surname, Userprincipalname, title, physicalDeliveryOfficeName -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" |
    Select-object GivenName, Surname, Userprincipalname, title, physicalDeliveryOfficeName |
    Export-csv -path c:\ScriptOutput\ActiveDirectoryUserList_$((Get-Date).ToString('MM-dd-yyyy')).csv