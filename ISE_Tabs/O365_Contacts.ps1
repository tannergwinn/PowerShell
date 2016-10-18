# O365 Contacts

#get the list

Get-MsolContact | Select-Object Displayname, FirstName, LastName, Emailaddress, objectId | Export-Csv C:\ScriptOutput\O365Contacts_$((Get-Date).ToString('MM-dd-yyyy')).csv

#bulk remove

$O365Contacts = Import-Csv C:\ScriptSources\O365Contacts_10-05-2016Test.csv

foreach ($OC in $O365Contacts)

{
Remove-MsolContact -ObjectId $OC.ObjectID -Force
}


