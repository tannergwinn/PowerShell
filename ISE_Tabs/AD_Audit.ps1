Get-ADUser -filter *  -properties passwordlastset, LastLogonTimestamp, Whencreated, DistinguishedName, Whenchanged  |
    Select-object Name, passwordlastset, @{n='LastLogonTimestamp';e={[DateTime]::FromFileTime($_.LastLogonTimestamp)}}, Whencreated, whenchanged, DistinguishedName |
    Export-csv -path c:\ScriptsOutput\ADAccess_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv