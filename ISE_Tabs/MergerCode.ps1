$Users = Import-Csv C:\ScriptsOutput\UPNChange.csv

           
foreach ($User in $Users)
            
{  

  $SAM = $User.'Samaccountname'
  $UPN = $User.'UPNprefix' + "@"  + "colonystarwood.com"            
  $Email = $User.'UPNprefix' + "@" + "colonystarwood.com"
  $Proxy = $user.'UPNprefix' + "@" + "colonyamerican.com"

  Get-ADUser $SAM | Set-ADUser -UserPrincipalName $UPN -EmailAddress $Email -Add @{ProxyAddresses="smtp:$Proxy"} 

  }



  $Users = Import-Csv C:\ScriptsOutput\cshproxy.csv

           
foreach ($User in $Users)
            
{  
  $SAM = $User.'Samaccountname'

  $Proxy = $user.'Samaccountname' + "@" + "Waypointhomes.com"

  Get-ADUser $SAM | Set-ADUser -Add @{ProxyAddresses="SMTP:$Proxy"} 

}


 $ADobjects = Import-Csv C:\ScriptsOutput\WPG.csv

           
foreach ($Userobject in $ADobjects)

{

Get-aduser $Userobject.SamAccountName | Set-ADUser -clear ProxyAddresses 

}

Get-aduser -Filter * -Properties * -SearchBase "OU=CAF_Users,DC=colonyah,DC=local"  | Set-ADUser -clear ProxyAddresses 


#Set the UPN's
$UPNS = import-csv C:\ScriptsOutput\NewUPN.csv

foreach ($upn in $upns)
{

Set-MsolUserPrincipalName -UserPrincipalName $upn.TempUPN -NewUserPrincipalName $upn.NewUPN 
}

Set-MsolUserPrincipalName -UserPrincipalName $TempUPN -NewUserPrincipalName $NewUPN



$UPNS = import-csv C:\ScriptsOutput\NewUPN.csv

foreach ($upn in $upns)
{
$Ename = "$upn.UPNprefix"
$OldUPN = "$Ename@colonyamerican.com"
$TempUPN = "$Ename@colonyamerican.onmicrosoft.com"
$NewUPN = "$ename@colonystarwood.com"

Set-MsolUserPrincipalName -UserPrincipalName "$OldUPN" -NewUserPrincipalName $TempUPN 
}

Set-MsolUserPrincipalName -UserPrincipalName $TempUPN -NewUserPrincipalName $NewUPN


  $Users = Import-Csv C:\ScriptsOutput\UPNChange.csv

           
foreach ($User in $Users)
            
{  
  $SAM = $User.'Samaccountname'

  $Proxy = $user.'UPNprefix' + "@" + "ColonyStarwood.com"

  Get-ADUser $SAM | Set-ADUser -Add @{ProxyAddresses="SMTP:$Proxy"} 

}


#Set up temp accounts

$Temps = Import-Csv C:\ScriptSources\SWAY_TEMPS_0112.csv

foreach ($Temp in $Temps)


{

$SAM = $Temp.'SAM'
$FN = $Temp.'FirstName'
$LN = $temp.'LastName'
$OldEmail = $Temp.'Old Email'
$Title = $temp.'Title'
$PW = $temp.'Password'
$TUPN = $SAM +  "@" + "ColonyStarwood.com"
$Dname = $FN + " " + $LN

New-ADUser -Name "$Dname" -DisplayName "$Dname" -SamAccountName $SAM -GivenName "$FN" -Surname "$LN" -UserPrincipalName $TUPN -Office "TEMP EMPLOYEE" -EmailAddress $TUPN -Title "$Title" -Path "OU=SWAY_Temp_Emloyees,OU=CAH_Users,DC=colonyah,DC=local" -OtherAttributes @{Proxyaddresses = "SMTP:$OldEmail"} -AccountPassword (ConvertTo-SecureString $PW -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $True –PasswordNeverExpires $false

}


$Users = Import-Csv C:\ScriptSources\SWAY_TEMPS_0112.csv
           
foreach ($User in $Users)            
{            
    $Displayname = $User.'Firstname' + " " + $User.'Lastname'            
    $UserFirstname = $User.'Firstname'            
    $UserLastname = $User.'Lastname'            
    $OU = $User.'OU'            
    $SAM = $User.'SAM'            
    $UPN = $User.'SAM' + "@" + "Colonystarwood.com"            
    $Description = $User.'Title'            
    $Password = $User.'Password'            
    New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName $SAM -UserPrincipalName $UPN -GivenName "$UserFirstname" -Surname "$UserLastname" -Description "$Description" -EmailAddress $UPN -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path "$OU" -ChangePasswordAtLogon $true –PasswordNeverExpires $false            
}


$Users = Import-Csv C:\ScriptSources\SWAY_TEMP_Check.csv
           
foreach ($User in $Users)
{

Get-ADUser "$user" | Set-ADUser -AccountPassword (ConvertTo-SecureString "Colony0112" -AsPlainText -Force) -Enabled $true

}

         
