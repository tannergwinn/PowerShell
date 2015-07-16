function Remove-MSOL{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String]$user
)
$user = Read-Host "Enter email"

Get-MsolUser -UserPrincipalName $user
    Set-MsolUserLicense -UserPrincipalName $user -RemoveLicenses Colonyamerican:STANDARDPACK
    Remove-MsolUser -UserPrincipalName $user -Force
    Remove-MsolUser -UserPrincipalName $user -RemoveFromRecyclebin
}