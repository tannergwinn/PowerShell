#Empty All Site Collections Recycle Bins

param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
[string[]]$Urls)
BEGIN
{
    Write-Host "Input your credentials:"
    $credentials = Get-Credential
}
PROCESS
{
    foreach ($url in $Urls)
    {
        Write-Host "Porocessing site:" $url

        $clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($url);
        # SPO-D or On-Prem
        #$clientContext.Credentials = $credentials.GetNetworkCredential();
        #$clientContext.AuthenticationMode = [Microsoft.SharePoint.Client.ClientAuthenticationMode]::Default
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
                break
            }

            Write-Host "Recycle Bin has" $recycleBinCollection.Count "items."
            $recycleBinCollection.DeleteAll();
            $clientContext.Load($recycleBinCollection)
            $clientContext.ExecuteQuery();
            Write-Host "Complete. Recycle Bin has" $recycleBinCollection.Count "items."
        }
        else
        {
          Write-Host "Could not connect to the site collection. Please check the url and try again.";
        }
    }
}
END
{
    Write-Host "All Complete."
}