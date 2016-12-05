##OneDrive
##You can connect to a OneDrive for Business site by using the Get-SPOSite cmdlet, and can change ownership by using the Set-SPOSite cmdlet. 
##Once you are an owner of the site, you can use regular SharePoint Client Side Object Model (CSOM) to take further management operations.
############################################################################################################################################

#Get Connected
$credentials = Get-Credential
Connect-SPOService -Url https://colonyamerican-admin.sharepoint.com -credential $credentials
Import-Module Microsoft.Online.Sharepoint.PowerShell

#Edit Permissions

$Owner = write SysAdmins_Internal@Colonyamerican.onmicrosoft.com

$site = write bryan_gordon_colonystarwood_com

#Admin Listing SysAdmins_Internal@Colonyamerican.onmicrosoft.com


Set-SPOsite -identity https://colonyamerican-my.sharepoint.com/personal/$site  -Owner $Owner -NoWait

Get-SPOSite -identity https://colonyamerican-my.sharepoint.com/personal/$site | FL





##############
#Scratch pad
##############

Set-SPOUser -site https://colonyamerican-my.sharepoint.com/personal/$site -LoginName $Owner -IsSiteCollectionAdmin $True

$site = Get-SPOSite  https://colonyamerican-my.sharepoint.com/personal/bryan_gordon_colonystarwood_com

$group = New-SPOSiteGroup -Site $site -Group "Designers" -PermissionLevels "Design","Edit"

get-spoSitegroup -site https://colonyamerican-my.sharepoint.com/personal/bryan_gordon_colonystarwood_com | where {$_.title -like "*Owners"}


 Get-SPOSite https://colonyamerican-my.sharepoint.com/personal/ariel_hart_colonystarwood_com | FL
