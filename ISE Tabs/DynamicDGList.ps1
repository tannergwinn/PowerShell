Jason.Tillett@colonyameircan.com
Irene.Panin@colonyameircan.com
Kristin.Emde@colonyamerican.com



$DDG = Get-DynamicDistributionGroup "Property Management - Riverside"

Foreach ($dg in $DDG)
{
Get-Recipient -RecipientPreviewFilter $DG.RecipientFilter | Select-Object DisplayName, @{Name=“DDG.Name”;Expression={$dg.Name}} #| Export-csv C:\ScriptsOutput\DDG.csv -append -force
}


@{Name=“EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_ -LIKE “SMTP:*”}}}
@{Name=“DDG.Name”;Expression={$dg.Name}}