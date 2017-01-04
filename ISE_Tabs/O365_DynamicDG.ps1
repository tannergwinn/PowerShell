$creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://outlook.office365.com/powershell-liveid/  `
    -Credential $creds -Authentication Basic -AllowRedirection
Import-PSSession $Session


#Get Dynamic list Members - Export
$DDG = Get-DynamicDistributionGroup "TechnologyDepartment"

Foreach ($dg in $DDG)
{
Get-Recipient -RecipientPreviewFilter $DG.RecipientFilter -ResultSize "Unlimited" | Select-Object DisplayName, @{Name=“DDG.Name”;Expression={$dg.Name}} | Export-csv C:\ScriptOutput\$DDG$((Get-Date).ToString('MM-dd-yyyy')).csv
}

#Get members of single list - Count

$DG = Get-DynamicDistributionGroup "Corporate - All"

Get-Recipient -RecipientPreviewFilter $DG.RecipientFilter | Select-Object DisplayName, @{Name=“DDG.Name”;Expression={$dg.Name}} | Measure

#Get Dynamic List Filter
Get-DynamicDistributionGroup "TechnologyDepartment" | fl recipientfilter

#Set Dunamic List filter- !!! do not forget the "{}" around the filter value !!!

#Template --> Get-DynamicDistributionGroup PropertyManagement-AltamonteSprings | Set-DynamicDistributionGroup -recipientfilter {<PutFilterHere>}

Get-DynamicDistributionGroup "TechnologyDepartment" | Set-DynamicDistributionGroup -recipientfilter {(RecipientTypedetails -eq 'UserMailbox') -and (Department -like 'IT -*') -and (-not(RecipientContainer -like 'OU=CAH_MailBox_Backup,DC=colonyah,DC=local'))}

Get-DynamicDistributionGroup "CSH-ALL" | Set-DynamicDistributionGroup -recipientfilter {(RecipientTypedetails -eq 'UserMailbox') -and (-not(Company -like 'Colony American Finance*'))}

Get-DynamicDistributionGroup "ScottsdaleOffice" | Set-DynamicDistributionGroup -recipientfilter { ((RecipientType -eq 'UserMailbox') -and (Office -like 'Scottsdale')) -and (((-not(Name -like 'SystemMailbox{*')) -and (-not(Title -like 'Call Center Agent'))))}


#Create dynamic distribution list

New-DynamicDistributionGroup -Name "Leasing Consultants" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Title -like 'Leasing Consultant')}

New-DynamicDistributionGroup -Name "Service Operations - All" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Department -like 'Service Operations')}



New-DynamicDistributionGroup -Name "Corporate - All" -RecipientFilter {(RecipientTypedetails -eq 'UserMailbox') -and (-not(Department -like 'Property Management')) -and (-not(Department -like 'Service Operations'))}



RecipientContainer

@{Name=“EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_ -LIKE “SMTP:*”}}}
@{Name=“DDG.Name”;Expression={$dg.Name}}