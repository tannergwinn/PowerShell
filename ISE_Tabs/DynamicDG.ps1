

#review Dynamic list Members
$DDG = Get-DynamicDistributionGroup "Service Managers"

Foreach ($dg in $DDG)
{
Get-Recipient -RecipientPreviewFilter $DG.RecipientFilter | Select-Object DisplayName, @{Name=“DDG.Name”;Expression={$dg.Name}} #| Export-csv C:\ScriptsOutput\DDG.csv -append -force
}

#Review Filter
Get-DynamicDistributionGroup ServiceManagers@colonyamerican.com | fl recipientfilter

#edit filter- !!! do not forget the "{}" around the filter value !!!

Get-DynamicDistributionGroup PropertyManagement-AltamonteSprings | Set-DynamicDistributionGroup -recipientfilter {<PutFilterHere>}

Get-DynamicDistributionGroup ServiceManagers@colonyamerican.com | Set-DynamicDistributionGroup -recipientfilter {((((RecipientType -eq 'UserMailbox') -and (Title -like 'Service Manager') -or (Title -like 'Service Operations Manager'))) -and (-not(Name -like 'SystemMailbox{*')) -and (-not(Name -like 'CAS_{*')) -and (-not(RecipientTypeDetailsValue -eq 'MailboxPlan')) -and (-not(RecipientTypeDetailsValue -eq 'DiscoveryMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'PublicFolderMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'ArbitrationMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'AuditLogMailbox')))}


#Create dynamic distribution list

New-DynamicDistributionGroup -Name "Property Management - Alamonte Springs" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Office -like 'Alamonte Springs')}



@{Name=“EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_ -LIKE “SMTP:*”}}}
@{Name=“DDG.Name”;Expression={$dg.Name}}