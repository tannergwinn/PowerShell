<#
.Synopsis
   Tool for pulling password last set date / Reseting password expiration date to today
.DESCRIPTION
  Enter users first name to find out when the password was last set / SamAccountName / reseting pwdlastset attribute
.EXAMPLE
   
Get-PwdExpired -FirstName John

FirstName: John

Name         SamAccountName Passwordlastset     
----         -------------- ---------------     
John Bradley J.Bradley      2/24/2015 7:24:01 AM
John Wasser  J.Wasser       4/9/2015 1:29:47 PM 
John Price   J.Price        3/26/2015 2:20:46 PM
John Hart    J.Hart         4/4/2015 9:01:55 AM 

.EXAMPLE2

Set-PwdLastSet -SamAccountName J.Price

#>

Function Get-PwdExpired{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
    [String]$FirstName
)

 Get-ADUser -filter {(GivenName -like $FirstName) -and (enabled -eq $true)} -Properties Name, Passwordlastset,SamAccountName |
  Select-Object Name, SamAccountName, Passwordlastset | Format-Table -AutoSize
 }

Function Set-PwdLastSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
    [String]$SamAccountName)Get-ADUser $SamAccountName | Set-ADAccountControl -PasswordNeverExpires $false$TargetUser = Get-ADUser -Filter {sAMAccountName -eq $SamAccountName}$uObj = [ADSI]"LDAP://$TargetUser"$uObj.put("pwdLastSet", 0)$uObj.SetInfo()$uObj.put("pwdLastSet", -1)$uObj.SetInfo()}
