Break
##Add date /time pulled
_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss'))

#Bulk Change users pswd last set date to today .csv

Import-Module ActiveDirectory
 
$users = import-csv "C:\ScriptInput\CRMUsers.csv"

foreach ($user in $users)

{
Get-ADUser $user | Set-ADAccountControl -PasswordNeverExpires $false
$TargetUser = Get-ADUser -Filter {sAMAccountName -eq $user}
$uObj = [ADSI]"LDAP://$TargetUser"
$uObj.put("pwdLastSet", 0)
$uObj.SetInfo()
$uObj.put("pwdLastSet", -1)
$uObj.SetInfo()
}


#Pull password expired

Get-ADUser -filter  'enabled -eq $true'  -properties passwordlastset, passwordneverexpires, LastLogonDate, sAMAccountName, company  |
    select-object Name, passwordlastset, LastLogonDate, passwordneverexpires, sAMAccountName, company |
    Export-csv -path c:\ScriptsOutput\PswExpired2.csv


#use LogonTimestamp for Logon

Get-ADUser -filter  'enabled -eq $true'  -properties passwordlastset, passwordneverexpires, LastLogonTimestamp, sAMAccountName, company  |
    select-object Name, passwordlastset, @{n='LastLogonTimestamp';e={[DateTime]::FromFileTime($_.LastLogonTimestamp)}}, passwordneverexpires, sAMAccountName, company |
    Export-csv -path c:\ScriptsOutput\PswExpired2.csv


#Bulk remove group members from AD Group (uses logon name)

$users = Import-CSV "c:\ScriptSources\Offboard.csv"

Foreach ($user in $users)

{
  Get-aduser  -Filter "SamAccountName -eq '($user.SAMAccountName)'" -Properties * -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local" |
    Remove-ADPrincipalGroupMembership -MemberOf "O365_Users" -Confirm:$false
}

#Single user remove from group

$user = write L.Pittman

  Get-aduser  -Filter "SamAccountName -eq '$user'" -Properties * -SearchBase "OU=CAH_MailBox_Backup,DC=colonyah,DC=local" |
    Remove-ADPrincipalGroupMembership -MemberOf "O365_Users" -Confirm:$false


#Update users attributes in AD in bulk

Import-Module ActiveDirectory            
      
$users = Import-Csv -Path C:\temp\UpdateADAttributes.csv            
    
            
foreach ($user in $users) 

{            
Get-ADUser -Filter "SamAccountName -eq '$user" -Properties * -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" 
 |            
  Set-ADUser -MobilePhone $($user.MobilePhone) -OfficePhone $($user.OfficePhone)
}


#Inactive items

Search-ADAccount -accountinactive -ComputersOnly | Export-Csv c:\temp\OutdatedComputers.csv


# 2 ways to get same data
Get-WmiObject -Class win_32_bios -ComputerName (Get-ADComputer -filter * ).name

Get-ADComputer -Filter * | Get-WmiObject win_32_bios -ComputerName {$_.Name}

#Connect via PS

Enter-PSSession -ComputerName 

#Query users manager name
(get-aduser (get-aduser A.hart -Properties manager).manager).name
 
#Query users manager extended properties
(get-aduser (get-aduser A.hart -Properties manager).manager -Properties EmployeeID).EmployeeID

#Pull list of users by title

Get-ADUser -Filter {(Enabled -eq $true) -and (title -like "Service Technician") -or (title -like "Service Manager") -or(title -like "Field Project Manager") -or (title -like "Leasing Consultant") -or (title -like "service operations manager")} -Properties Displayname, mail, title, physicalDeliveryOfficeName |
    Select-Object Displayname, mail, title, physicalDeliveryOfficeName |
    Export-Csv C:\ScriptsOutput\SM-TM-FM-KitchenSink.csv

#Pull list of users in group
Get-ADGroupMember "CAH-Managers" | Export-csv -path C:\ScriptsOutput\CAHMAnagerAD.csv

#Look up expired password

Function Get-PSWEXP{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
    [String]$FirstName
)

 Get-ADUser -filter {(GivenName -like $user) -and (enabled -eq $true)} -Properties Name, Passwordlastset |
  Select-Object Name, Passwordlastset | Format-Table -AutoSize
 }

 #filter like export results

 Get-ADUser -filter {(Title -like "Service Operations Manager") -and (enabled -eq $true)} -Properties physicalDeliveryOfficeName, MobilePhone, manager, title, mail | Select-Object Name, Title, mail, physicalDeliveryOfficeName, MobilePhone, @{Name='Manager';Expression={(get-aduser (get-aduser $_ -Properties manager).manager).name}} | Export-Csv C:\ScriptOutput\SOM.csv
#reset password last set -use SAMAccountImport-Module ActiveDirectory$users = Get-ADUser -filter 'enabled -eq $true' -Properties SamAccountName -SearchBase "OU=CAF_Users,DC=colonyah,DC=local" foreach ($user in $users){$TargetUser = $user.SamAccountName$uObj = [ADSI]"LDAP://$TargetUser"$uObj.put("pwdLastSet", 0)$uObj.SetInfo()$uObj.put("pwdLastSet", -1)$uObj.SetInfo()}

#Origional Change password last set date

Import-Module ActiveDirectory

$users = write t.woods #get-content "C:\ScriptsOutput\ExpiredCRM.csv" foreach ($user in $users){Get-ADUser $user | Set-ADAccountControl -PasswordNeverExpires $false$TargetUser = Get-ADUser -Filter {sAMAccountName -eq $user}$uObj = [ADSI]"LDAP://$TargetUser"$uObj.put("pwdLastSet", 0)$uObj.SetInfo()$uObj.put("pwdLastSet", -1)$uObj.SetInfo()}#Get users email address from SAMAccountName$SmartU = Import-Csv "C:\ScriptSources\Smart_Search_Results.csv"

#Find hidden from GAL
Get-ADGroup -filter 'msExchHideFromAddressLists -eq $True' | Select-Object Name

Foreach ($SU in $SmartU)

{Get-ADUser $SU.samaccountname -Properties mail | Export-Csv C:\ScriptsOutput\iPhone.csv -Append}

#fetch, sort and filter computers

Get-ADComputer -filter {cn -like "PRNT*"} -Properties  LastLogonTimestamp|
 Sort-Object -property LastLogonTimestamp |
 Select-Object Name, @{n='LastLogonTimestamp';e={[DateTime]::FromFileTime($_.LastLogonTimestamp)}} -last 5 |
 Format-Table -AutoSize

\\dfs01\IT\IT - Public\Printers\prnt02

#Move AD computer
get-adcomputer A1981591 | Move-ADObject -TargetPath "OU=LasVegas,OU=CAH_Computers,DC=colonyah,DC=local"

#Find some people, get some stuff
Get-ADUser -filter {(title -like "Property Manager") -or (title -like "Leasing Manager") -and (enabled -eq $true)} -Properties Displayname, physicalDeliveryOfficeName, title | Select-Object Displayname, physicalDeliveryOfficeName, title |Export-Csv C:\Scriptsoutput\PM_LM.csv

# Bulk add to group
$users = Get-ADUser -Filter * -Properties * -SearchBase "OU=CAH_Users,DC=colonyah,DC=local"

foreach ($user in $users) 

{
Add-ADGroupMember -Identity "Colony American Drive" -Members $user
Add-ADGroupMember -Identity "VPN Access" -Members $user
} 

#Bulk Remove-ADuser from Group(s) by OU

$RMGusers = Get-ADUser -Filter * -Properties * -SearchBase "OU=CAH_Mailbox_backup,DC=colonyah,DC=local"

foreach ($user in $RMGusers) 

{
#Remove-ADGroupMember -Identity "Colony American Drive" -Members $user -Confirm:$false
#Remove-ADGroupMember -Identity "VPN Access" -Members $user -Confirm:$false
Remove-ADGroupMember -Identity "Atlas" -Members $user -Confirm:$false
} 

#fetch SamAccountName
Import-Module ActiveDirectory
$users = Import-Csv #PathToSourceFile

foreach ($user in $users) 

{
Get-ADUser -filter {(DisplayName -like "$($User.Name)" -and (enabled -eq $true)} -Properties Displayname, SamAccountName, physicalDeliveryOfficeName | Select-Object Displayname, SamAccountName, physicalDeliveryOfficeName |Export-Csv #WhereToSaveData
}



#pull employee list
Get-ADUser -Filter * -Properties Displayname, mail, title, physicalDeliveryOfficeName -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" | 
    Select-Object Displayname, mail, title, physicalDeliveryOfficeName |
    Export-Csv C:\ScriptsOutput\EmployeeScrub.csv -Append



#bulk import users to AD
$Users = Import-Csv -Path "C:\users\a.hart\Desktop\WaypointUsers.csv" 
           
foreach ($User in $Users)            
{            
    $Displayname = $User.'GivenName' + " " + $User.'SurName'            
    $UserFirstname = $User.'GivenName'            
    $UserLastname = $User.'SurName'            
    $OU = $User.'OU'            
    $SAM = $User.'SAM'            
    $UPN = $User.'SAM' + "@"  + "colonystarwood.com"            
    $Email = $User.'SAM' + "@" + "colonystarwood.com"
    $Department = $User.'Department'
    $Title = $user.'Title'       
    $Password = $User.'Password' 
    $Comapany = "Colony Starwood Homes"
    $Phone = $user.'OfficePhone'  
    $office = $user.'Office'
             
    New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName $SAM -UserPrincipalName $UPN -GivenName "$UserFirstname" -Surname "$UserLastname" -EmailAddress "$Email" -Department "$Department" -Title "$Title" -Company "$Company" -OfficePhone "$Phone" -Office "$Office" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path "$OU" -ChangePasswordAtLogon $true –PasswordNeverExpires $false         
   
} 

#Set them Passwords

#bulk import users to AD
$Users = Import-Csv -Path "C:\scriptsources\SwayImport2.csv" 
           
foreach ($User in $Users)            
{  

 $SAM = $User.'SAM'
 $Password = $User.'Password'


Get-aduser $Sam  | Set-ADAccountPassword -newpassword (ConvertTo-SecureString "$Password" -AsPlainText -Force) -Reset -PassThru | Enable-ADAccount
Write-host "AD Password has been reset for:"$SAM
}



$Users = Import-Csv -Path C:\scriptsoutput\failusers.csv

foreach ($User in $Users)  

{

$SAM = $User.SamAccountName

Get-ADUser $SAM | Move-ADObject -TargetPath 'OU=FailedUsers,OU=UserImport,OU=CAH_Users,DC=colonyah,DC=local'

}


#Add Proxy Address
set-aduser Finn.Rey -Add @{ProxyAddresses="smtp:Finn.Rey@colonyamerican.com"}


get-aduser -Filter * -Properties Displayname, Proxyaddresses -SearchBase 'OU=CAH_Users,DC=colonyah,DC=local'



Get-ADUser -Filter * -SearchBase 'OU=CAH_Users,DC=colonyah,DC=local' -Properties proxyaddresses |

select name, @{L='ProxyAddress_1'; E={$_.proxyaddresses[0]}},

@{L='ProxyAddress_2';E={$_.ProxyAddresses[1]}}, @{L='ProxyAddress_3';E={$_.ProxyAddresses[2]}}, @{L='ProxyAddress_4';E={$_.ProxyAddresses[3]}}|

Export-Csv -Path C:\ScriptsOutput\Proxies0106.csv


#Bulk Offboard

$Users = Import-Csv -Path C:\ScriptSources\UserRecords0215.csv
           
foreach ($User in $Users)            
{  

 $SAM = $User.'SAM'
 $Password = $User.'Password'


Get-ADUser $SAM | Move-ADObject -TargetPath "OU=CAH_MailBox_Backup,DC=colonyah,DC=local"
Get-aduser $Sam  | Set-ADAccountPassword -newpassword (ConvertTo-SecureString "$Password" -AsPlainText -Force) -Reset -PassThru
Write-host "User Turned Down:"$SAM
}

#UserList
Get-ADUser -Filter * -Properties Displayname, Title, Office, Department, Manager, telephoneNumber, StreetAddress, MobilePhone, EmployeeID, Userprincipalname -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" |
Select-Object Displayname, Title, Office, Department, telephoneNumber, MobilePhone, EmployeeID, Manager, Userprincipalname | 
Export-Csv "C:\ScriptsOutput\AD_Pull_$((Get-Date).ToString('MMddyy')).csv"

#Get users password last set / last login **Audit**
Get-ADUser -filter  "Surname -eq 'Torres'"  -properties passwordlastset, LastLogonTimestamp |
    Select-object Name, passwordlastset, @{n='LastLogonTimestamp';e={[DateTime]::FromFileTime($_.LastLogonTimestamp)}}


#Search a body's by last name
Get-ADUser -Filter 'surname -like "peterson"' -Properties Title, Office, company

Get-ADUser -Filter * -Properties DisplayName, Description


#Look up AD data based on list

$Users = Import-Csv -Path 'C:\users\a.hart\Downloads\Google Users.csv'
           
foreach ($User in $Users)            
{  

 $DisplayName = $User.'Users'
 

Get-ADUser -filter {(Displayname -like $Displayname) -and (enabled -eq $true)} -Properties GivenName, Surname, mail | Select-Object GivenName, Surname, mail | Export-Csv C:\ScriptOutput\GoogleUserContactDetails.csv -Append
}

Get-ADUser -filter {(Displayname -like 'Francisco*') -and (enabled -eq $true)} -Properties GivenName, Surname, mail | Select-Object GivenName, Surname, mail