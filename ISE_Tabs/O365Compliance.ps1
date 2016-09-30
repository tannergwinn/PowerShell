#O365 Compliance search tools
#Preface all commands with cc so they do not clash with exchange online 
#.pst files only avalible in the Security & Compliance Center portal

#Login

$UserCredential = Get-Credential 
$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $credential -Authentication Basic -AllowRedirection
Import-PSSession $ccSession -Prefix cc -AllowClobber -DisableNameChecking 
$Host.UI.RawUI.WindowTitle = $UserCredential.UserName + " (Office 365 Security & Compliance Center)" 

#Setup search
New-ccComplianceSearch -Name "Phishing 09.29.16" -ExchangeLocation all -ContentMatchQuery 'From:fred.tuomi@outlook.com'

    ##Query examples
    #(Received:4/13/2016..4/14/2016) AND (Subject:'Action required')
    #'From:chatsuwloginsset12345@outlook.com'


#Start Search

Start-ccComplianceSearch "Phishing 09.29.16"

#Get all compliance searches

Get-ccComplianceSearch  | Format-Table  -AutoSize


#get 1 search stats 

Get-ccComplianceSearch "Phishing 09.22.16" | Fl

New-ccComplianceSearchAction -SearchName "Phishing 09.22.16" -

Get-ccComplianceSearchAction -Identity "Phishing 09.22.16_Preview" | FL

#Export emails

New-ccComplianceSearchAction -SearchName "Phishing 09.22.16" -Export
Get-ccComplianceSearchAction -Identity "Phishing 09.22.16_Purge"

#Remove messages

New-ccComplianceSearchAction -SearchName "Phishing 09.22.16" -Purge


#Edit search

Set-ccComplianceSearch -Identity "Phishing 09.22.16" -ContentMatchQuery 'From:maxwellcarton120@outlook.com'



set-OwaMailboxPolicy -GroupCreationEnabled $false -Identity OwaMailboxPolicy-Default

Get-OwaMailboxPolicy -Identity OwaMailboxPolicy-Default | Select-Object Identity, GroupCreationEnabled