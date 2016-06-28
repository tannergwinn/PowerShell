

#review Dynamic list Members
$DDG = Get-DynamicDistributionGroup "TechnologyDepartment"

Foreach ($dg in $DDG)
{
Get-Recipient -RecipientPreviewFilter $DG.RecipientFilter -ResultSize "Unlimited" | Select-Object DisplayName, @{Name=“DDG.Name”;Expression={$dg.Name}} | Export-csv C:\ScriptOutput\Technology_DDG.csv -append -force
}

#Pull members of single list

$DG = Get-DynamicDistributionGroup "Call Center"

Get-Recipient -RecipientPreviewFilter $DG.RecipientFilter | Select-Object DisplayName, @{Name=“DDG.Name”;Expression={$dg.Name}} | Measure

#Review Filter
Get-DynamicDistributionGroup "ScottsdaleOffice" | fl recipientfilter

#edit filter- !!! do not forget the "{}" around the filter value !!!

Get-DynamicDistributionGroup PropertyManagement-AltamonteSprings | Set-DynamicDistributionGroup -recipientfilter {<PutFilterHere>}

Get-DynamicDistributionGroup "CSH-ALL" | Set-DynamicDistributionGroup -recipientfilter {(RecipientTypedetails -eq 'UserMailbox') -and (-not(Company -like 'Colony American Finance*'))}

Get-DynamicDistributionGroup "ScottsdaleOffice" | Set-DynamicDistributionGroup -recipientfilter { ((RecipientType -eq 'UserMailbox') -and (Office -like 'Scottsdale')) -and (((-not(Name -like 'SystemMailbox{*')) -and (-not(Title -like 'Call Center Agent'))))}


#Create dynamic distribution list

New-DynamicDistributionGroup -Name "Property Administrators" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Title -like 'Property Administrator')}

New-DynamicDistributionGroup -Name "Call Center" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Department -like 'Call Center')}


@{Name=“EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_ -LIKE “SMTP:*”}}}
@{Name=“DDG.Name”;Expression={$dg.Name}}