

#review Dynamic list Members
$DDG = Get-DynamicDistributionGroup "Property Management - Riverside"

Foreach ($dg in $DDG)
{
Get-Recipient -RecipientPreviewFilter $DG.RecipientFilter | Select-Object DisplayName, @{Name=“DDG.Name”;Expression={$dg.Name}} #| Export-csv C:\ScriptsOutput\DDG.csv -append -force
}

#Review Filter
Get-DynamicDistributionGroup PropertyManagement-AltamonteSprings | fl recipientfilter

#edit filter- !!! do not forget the "{}" around the filter value !!!

Get-DynamicDistributionGroup PropertyManagement-AltamonteSprings | Set-DynamicDistributionGroup -recipientfilter {<PutFilterHere>}


#Create dynamic distribution list

New-DynamicDistributionGroup -Name "Property Management - Alamonte Springs" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Office -like 'Alamonte Springs')}



@{Name=“EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_ -LIKE “SMTP:*”}}}
@{Name=“DDG.Name”;Expression={$dg.Name}}