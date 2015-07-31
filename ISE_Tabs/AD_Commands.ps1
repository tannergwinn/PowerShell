Break

#Bulk change attributes

Import-Module ActiveDirectory            
                
$users = Import-Csv -Path C:\ScriptSources\SAMName224.csv                      
        
foreach ($user in $users)

{            
Get-ADUser -Filter "SamAccountName -eq '$($user.SAMAccountName)'" -Properties Title, Department -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" |
    Set-ADUser -Title "$($user.Title)" -Department "$($user.Department)" -Office "$($user.Office)" -Manager "$($User.Manager)"  -verbose -PassThru -EA stop
}

#Change users pswd last set date to today

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
Get-ADUser -Filter "SamAccountName -eq '$($user.samaccountname)'" -Properties * -SearchBase "OU=CAH_Users,DC=colonyah,DC=local" 
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

(get-aduser (get-aduser A.hart -Properties manager).manager).samaccountName

#Pull list of users by title

Get-ADUser -Filter {(title -like "Property Manager") -or (title -like "Regional Manager")} -Properties Displayname, mail, title |
    Select-Object Displayname, mail, title |
    Export-Csv C:\ScriptsOutput\PM-RM.csv


Get-ADGroupMember "CAH_Scottsdale" | Export-csv -path C:\ScriptsOutput\Alias.csv

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

 Get-ADUser -filter {(Title -like "Leasing Consultant") -and (enabled -eq $true)} -Properties * | Select-Object Name, Title, mail | Export-Csv C:\ScriptsOutput\Leasing.csv
#reset password last set -use SAMAccountImport-Module ActiveDirectory$users = Get-ADUser -filter 'enabled -eq $true' -Properties SamAccountName -SearchBase "OU=CRM,DC=colonyah,DC=local" foreach ($user in $users){$TargetUser = $user.SamAccountName$uObj = [ADSI]"LDAP://$TargetUser"$uObj.put("pwdLastSet", 0)$uObj.SetInfo()$uObj.put("pwdLastSet", -1)$uObj.SetInfo()}

#Origional

Import-Module ActiveDirectory

$users = write j.chang #get-content "C:\ScriptsOutput\ExpiredCRM.csv" foreach ($user in $users){Get-ADUser $user | Set-ADAccountControl -PasswordNeverExpires $false$TargetUser = Get-ADUser -Filter {sAMAccountName -eq $user}$uObj = [ADSI]"LDAP://$TargetUser"$uObj.put("pwdLastSet", 0)$uObj.SetInfo()$uObj.put("pwdLastSet", -1)$uObj.SetInfo()}#Get users email address from SAMAccountName$SmartU = Import-Csv "C:\ScriptSources\Smart_Search_Results.csv"

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
get-adcomputer A2200656 | Move-ADObject -TargetPath "OU=Englewood,OU=CAH_Computers,DC=colonyah,DC=local"

#Find some people, get some stuff
Get-ADUser -filter {(title -like "customer service *") -or (title -like "CSR")} -Properties Displayname, physicalDeliveryOfficeName | Select-Object Displayname, physicalDeliveryOfficeName |Export-Csv C:\Scriptsoutput\CSR.csv