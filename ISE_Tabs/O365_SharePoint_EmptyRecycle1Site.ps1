#Empty Single Site Collection Recycle Bin

Write-Host "Input your credentials:"
$credentials = Get-Credential

$url = Read-Host "Enter the URL of the site collection"
Write-Host "URL entered:" $url

$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($url);

# SPO/Office365
$clientContext.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($credentials.Username, $credentials.Password)

if (!$clientContext.ServerObjectIsNull.Value)
{
    Write-Host "Connected to site collection..."
    try
    {
        $site = $clientContext.Site
        $recycleBinCollection = $site.RecycleBin
        $clientContext.Load($site)
        $clientContext.Load($recycleBinCollection)
        $clientContext.ExecuteQuery()
    }
    catch
    {
        Write-Host "An error occured accesing the site. Check the URL and credentials. Error:" $_.Exception.Message
        return
    }

    Write-Host "Recycle Bin has" $recycleBinCollection.Count "items."
    $export = Read-Host "Export the item list? Y/N"
    if (($export -eq "Y") -or ($export -eq "y"))
    {
      $exportPath = Read-Host "Enter the path for the exported CSV file:"
      $recycleBinCollection.GetEnumerator() | Export-CSV $exportPath
    }
    
    $proceed = Read-Host "Proceed with empty of Recycle Bin? This is irreversible. Y/N"
    if (($proceed -eq "Y") -or ($proceed -eq "y"))
    {
      $recycleBinCollection.DeleteAll();
      $clientContext.Load($recycleBinCollection)
      $clientContext.ExecuteQuery();
    }
    Write-Host "Complete. Recycle Bin has" $recycleBinCollection.Count "items."
}
else
{
  Write-Host "Could not connect to the site collection. Please check the url and try again.";
}