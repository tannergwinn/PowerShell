#O365 Compliance search tools                                            #
#Preface all commands with cc so they do not clash with exchange online  #
#.pst files only avalible in the Security & Compliance Center portal     #
##########################################################################

#Login, import commands

$UserCredential = Get-Credential 
$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $credential -Authentication Basic -AllowRedirection
Import-PSSession $ccSession -Prefix cc -AllowClobber -DisableNameChecking 

#Sets ISE window title
#$Host.UI.RawUI.WindowTitle = $UserCredential.UserName + " (Office 365 Security & Compliance Center)" 

############################
##Set search name as variable
    
   $SearchName = "Phishing 03/02/17 col0nystarwo0d.com"

########################################################
##Create new compliance search with name set as variable
##Query examples at end of file

    New-ccComplianceSearch -Name $SearchName -ExchangeLocation all -ContentMatchQuery 'From:ftu0mi@col0nystarwo0d.com'

##################
##Start search job

    Start-ccComplianceSearch $SearchName

#####################################
##Get status of jobs

    Get-ccComplianceSearch  | Format-Table  -AutoSize

######################
##Start Search Actions

    New-ccComplianceSearchAction -SearchName $SearchName -Preview

#Export emails

    New-ccComplianceSearchAction -SearchName $SearchName -Export

#Remove messages

    New-ccComplianceSearchAction -SearchName $SearchName -Purge

#########################
##Get Search Action Status

Get-ccComplianceSearchAction #-Identity $SearchName | FL

#################################
##Edit existing search parameters

Set-ccComplianceSearch -Identity $SearchName -ContentMatchQuery 'Sent:08/30/2016..09/30/2016'


###################################################################################################################################################################
#Query Parameters Referance Link                                                                                                                                                   #
#https://support.office.com/en-us/article/Keyword-queries-and-search-conditions-for-Content-Search-c4639c2e-7223-4302-8e0d-b6e10f1c3be3?ui=en-US&rs=en-US&ad=US   #
###################################################################################################################################################################

    #(Received:4/13/2016..4/14/2016) AND (Subject:'Action required')
    #'(From:notice@office365.reply.com) OR (From:Alert@mailoffice12.com)'
    #'From:col0nystarwo0d.com'
    #'From:barb.otero@outlook.com'
    #Sent sent>=08/30/2016 AND sent<=09/30/2016
    #Sent 'Sent:08/30/2016..09/30/2016'
   