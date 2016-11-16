##OneDrive
##You can connect to a OneDrive for Business site by using the Get-SPOSite cmdlet, and can change ownership by using the Set-SPOSite cmdlet. 
##Once you are an owner of the site, you can use regular SharePoint Client Side Object Model (CSOM) to take further management operations.
############################################################################################################################################



#Get Connected
$credentials = Get-Credential
Connect-SPOService -Url https://colonyamerican-admin.sharepoint.com -credential $credentials
Import-Module Microsoft.Online.Sharepoint.PowerShell

#Edit Permissions

$Owner = erica.wicke@colonystarwood.com
$site = veronica_garcia_colonystarwood_com


Set-SPOsite -identity https://colonyamerican-my.sharepoint.com/personal/$sire  -Owner $Owner -NoWait

Get-SPOSite -identity https://colonyamerican-my.sharepoint.com/personal/veronica_garcia_colonystarwood_com