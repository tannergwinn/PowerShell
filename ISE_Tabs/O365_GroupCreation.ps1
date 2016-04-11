# Connect to EXO
$creds = Get-Credential
 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://outlook.office365.com/powershell-liveid/  `
    -Credential $creds -Authentication Basic -AllowRedirection
 
Import-PSSession $Session
 
# Check status
Get-OwaMailboxPolicy | fl GroupCreationEnabled 

#Disable Mobile User / OwaMailboxPolicy-Default

Set-OwaMailboxPolicy -Identity "Mobile Users" -GroupCreationEnabled $false

#Get Group information and export

$CRMGroups = Get-ADGroup -Filter * -SearchBase "OU=Affiliates,OU=CRM,DC=colonyah,DC=local"
foreach ($C in $CRMGroups)


{Get-MsolGroup -SearchString $C.name | Select-Object DisplayName, ObjectID | Export-Csv C:\Scriptsoutput\CRMGroups.csv -append}
 
