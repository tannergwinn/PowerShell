#enable Litigation Hold

#single mailbox
Set-Mailbox Ariel.hart@colonyamerican.com -LitigationHoldEnabled $true

#Set Lit hold on list of mailboxes

$LHold = Import-Csv C:\Users\a.hart\Desktop\TexusHold..csv

foreach ($LH in $LHold)
{

Set-Mailbox $LH.Userprincipalname -LitigationHoldEnabled $true

}

#Measure mailboxes not on Litigation Hold
Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize unlimited -Filter 'LitigationHoldEnabled -eq $false' | Measure

#Set Litigation Hold on new mailboxes

Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize unlimited -Filter 'LitigationHoldEnabled -eq $false' | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration 2555

#Set Litigation Hold on all mailboxes

Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox"} | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration 2555

