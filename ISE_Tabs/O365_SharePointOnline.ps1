Break

#Connect SharePointOnline
Connect-SPOService -Url https://colonyamerican-admin.sharepoint.com -credential Ariel.hart@colonystarwood.com
Import-Module Microsoft.Online.Sharepoint.PowerShell

Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

#Get all the Sites
Get-SPOSite | Select-Object Title, LastContentModifiedDate, Owner, Url | Export-csv C:\ScriptOutput\SharepointSitesList.csv

Get-SPOSite -Identity https://colonyamerican.sharepoint.com/sites/Technology | FL

Set-SPOSite -Identity https://colonyamerican.sharepoint.com/teams/QualityAssurance -Owner Ariel.hart@colonystarwood.com



#get the Groups of a site

Get-SPOSiteGroup -Site https://colonyamerican.sharepoint.com/sites/Technology | Select-Object Loginname | Export-Csv C:\ScriptOutput\SPOSiteGroups.csv

#Add users to a group of a site

Add-SPOUser -Site https://colonyamerican.sharepoint.com/sites/HomeBase -LoginName Randy.Melvin@colonystarwood.com -Group "PM & Leasing Owners"


##Change Sharepoint Sharing

$SPOSite = "https://colonyamerican.sharepoint.com/sites/TechnologyCompliance"

Set-SPOSite -Identity $SPOSite -SharingCapability ExternalUserAndGuestSharing
        
        #Other sharing options include:
        
        #Disabled – external user sharing (share by email) and guest link sharing are both disabled
        
        #ExternalUserSharingOnly – external user sharing (share by email) is enabled, but guest link sharing is disabled, or 
        
        #ExternalUserAndGuestSharing - external user sharing (share by email) and guest link sharing are both enabled.

##Check Sharepoint Shareing

Get-SPOSite -Identity $SPOSite | FL
        
##Set External Link Expiration time
#Set-SPOTenant –RequireAnonymousLinksExpireInDays 30 

#GUI for the Groups Setting

https://colonyamerican.sharepoint.com/sites/TechnologyCompliance/_layouts/15/groups.aspx














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