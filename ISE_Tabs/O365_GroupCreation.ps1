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
 
