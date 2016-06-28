#enable Litigation Hold

Set-Mailbox Ariel.hart@colonyamerican.com -LitigationHoldEnabled $true

$LHold = Import-Csv C:\Users\a.hart\Desktop\TexusHold..csv

foreach ($LH in $LHold)
{

Set-Mailbox $LH.Userprincipalname -LitigationHoldEnabled $true

}