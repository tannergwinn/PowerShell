#O365 Licensing Commands

#Batch remove licesnses and users from O365 (Uses email address)

$users = Import-Csv "C:\ScriptsOutput\DisabledAD.csv"

foreach ($user in $users)
{
Get-MsolUser -UserPrincipalName $user.UserPrincipalName
    Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -RemoveLicenses Colonyamerican:STANDARDPACK
    Remove-MsolUser -UserPrincipalName $user.UserPrincipalName -Confirm:$false
} 

##O365 Account license information 

#Pull Licenses
$AccountSku = Get-MsolAccountSku

#Count how many
$AccountSku.Count

#Pull data on each (1 line for each license)
$AccountSku[0].AccountSkuId
$AccountSku[1].AccountSkuId
$AccountSku[2].AccountSkuId
$AccountSku[3].AccountSkuId
$AccountSku[4].AccountSkuId
$AccountSku[5].AccountSkuId
$AccountSku[6].AccountSkuId
$AccountSku[7].AccountSkuId
$AccountSku[8].AccountSkuId


Get-MsolAccountSku

#For Each user loop to pull license data
$licensedetails = (Get-MsolUser -UserPrincipalName `
  "ariel.hart@colonystarwood.com").Licenses
$licensedetails.Count;
# If there's a license, show the details.
# Otherwise, the output is blank.
if ($licensedetails.Count -gt 0){
  foreach ($i in $licensedetails){
    $i.ServiceStatus
  }
}

#Pull list of unlicensed O365 Users

Get-MsolUser -All | 
Select-Object UserPrincipalName, DisplayName, isLicensed |
    Export-Csv C:\Temp\UnlicensesedToRemove.csv

#pull Licenses applied to user | #Export-Csv C:\Temp\E1ToRemove.csv

Get-MsolUser -all |Where {$_.IsLicensesed -eq $true} | Select-Object Displayname, @{n="Licenses Type";e={$_.Licenses.AccountSkuid}}, UserPrincipalname 


$lines = @()
foreach($msolUser in (Get-MSOLUser -All))
{
    $UserInfo = Get-MSOLUser -UserPrincipalName $msolUser.UserPrincipalName
    foreach($license in $msolUser.Licenses)
    {
        $lines += New-Object PsObject -Property @{
                    "Username"="$($UserInfo.DisplayName)";
                    "Company"="$($UserInfo.Company)";
                    "AccountSKUID"="$($license.AccountSKUid)"
                  }
    }
}
$lines | Export-CSV C:\scriptoutput\E1Licenses.csv

#User Licensing 

  $userLicenseTest = Get-MsolUser `
  -UserPrincipalName "Aiden.Hong@colonyamerican.com"

  $userLicenseTest.IsLicensed

#Get list by license type

get-MSOLUser -All | where {$_.isLicensed -eq "TRUE" -and $_.Licenses.AccountSKUID -eq "Colonyamerican:POWER_BI_STANDARD"} | select displayname,userprincipalname,isLicensed