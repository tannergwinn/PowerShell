Break

#Connect to O365
$LiveCred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session
connect-msolservice -credential $LiveCred


#Change to Cloud UPN

$Ename = "Servicedesk"
$OldUPN = "$Ename@colonyamerican.com"
$TempUPN = "$Ename@colonyamerican.onmicrosoft.com"

Set-MsolUserPrincipalName -UserPrincipalName "$OldUPN" -NewUserPrincipalName $TempUPN 

#Remove federation

    Get-MsolUser -UserPrincipalName $OldUPN
    Remove-MsolUser -UserPrincipalName $OldUPN  -Force
    Restore-Mailbox $OldUPN
    