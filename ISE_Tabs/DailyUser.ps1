

#Search a body's by last name
Get-ADUser -Filter 'surname -like "peterson"' -Properties Title, Office, company