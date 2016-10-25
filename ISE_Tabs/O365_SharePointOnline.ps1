Break

#Connect SharePointOnline
Connect-SPOService -Url https://colonyamerican-admin.sharepoint.com -credential Ariel.hart@colonystarwood.com
Import-Module Microsoft.Online.Sharepoint.PowerShell

#Get all the Sites
Get-SPOSite | Select-Object Title, LastContentModifiedDate, Owner, Url | Export-csv C:\ScriptOutput\SharepointSitesList.csv

-Identity https://colonyamerican.sharepoint.com/sites/YardiData



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