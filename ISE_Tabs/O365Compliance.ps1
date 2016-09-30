#O365 Compliance search tools
#Preface all commands with cc so they do not clash with exchange online 
#.pst files only avalible in the Security & Compliance Center portal

#Login

$UserCredential = Get-Credential 
$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $credential -Authentication Basic -AllowRedirection
Import-PSSession $ccSession -Prefix cc -AllowClobber -DisableNameChecking 
$Host.UI.RawUI.WindowTitle = $UserCredential.UserName + " (Office 365 Security & Compliance Center)" 

#Setup search
$SearchName = "Phishing 09.30.16 B.Otero"

New-ccComplianceSearch -Name $SearchName -ExchangeLocation barb.otero@colonystarwood.com -ContentMatchQuery 'Sent:08/30/2016..09/30/2016'

    ##Query examples
    #(Received:4/13/2016..4/14/2016) AND (Subject:'Action required')
    #'From:chatsuwloginsset12345@outlook.com'
    #Sent sent>=08/30/2016 AND sent<=09/30/2016
   
#Queue Search

Start-ccComplianceSearch $SearchName

#Get all compliance searches' status

Get-ccComplianceSearch  | Format-Table  -AutoSize

#Start Search

New-ccComplianceSearchAction -SearchName $SearchName -Preview

#Get Search Status

Get-ccComplianceSearchAction -Identity $SearchName | FL

#Export emails

New-ccComplianceSearchAction -SearchName $SearchName -Export

#Remove messages

#New-ccComplianceSearchAction -SearchName $SearchName -Purge

#Edit search

Set-ccComplianceSearch -Identity $SearchName -ContentMatchQuery 'Sent:08/30/2016..09/30/2016'



#Other Project
set-OwaMailboxPolicy -GroupCreationEnabled $false -Identity OwaMailboxPolicy-Default

Get-OwaMailboxPolicy -Identity OwaMailboxPolicy-Default | Select-Object Identity, GroupCreationEnabled