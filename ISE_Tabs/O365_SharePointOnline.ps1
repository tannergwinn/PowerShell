Break

#Connect SharePointOnline
Connect-SPOService -Url https://colonyamerican-admin.sharepoint.com -credential Ariel.hart@colonystarwood.com
Import-Module Microsoft.Online.Sharepoint.PowerShell

Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

#Get all the Sites
Get-SPOSite | Select-Object Title, LastContentModifiedDate, Owner, Url | Export-csv C:\ScriptOutput\SharepointSitesList.csv

Get-SPOSite -Identity https://colonyamerican.sharepoint.com/sites/HomeBase 

Set-SPOSite -Identity https://colonyamerican.sharepoint.com/sites/audit -Owner Ariel.hart@colonystarwood.com



#get the Groups of a site

Get-SPOSiteGroup -Site https://colonyamerican.sharepoint.com/sites/HomeBase | Select-Object Loginname | Export-Csv C:\ScriptOutput\SPOSiteGroups.csv

#Add users to a group of a site

Add-SPOUser -Site https://colonyamerican.sharepoint.com/sites/HomeBase -LoginName Randy.Melvin@colonystarwood.com -Group "PM & Leasing Owners"


















#Delete from SharePoint Online admin RecycleBin

Remove-SPODeletedSite -Identity 


################################################
#Delete 1 sites recycle bin export items to be deleted
#See dedicated script
################################################

#################################################
#Delete items from Recycle bin of all sites no export of items
#See dedicated script
#################################################