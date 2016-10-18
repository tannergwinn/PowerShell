#remove the proxy

Get-aduser -Filter * -Properties * -SearchBase "OU=CAF_Users,DC=colonyah,DC=local"  | Set-ADUser -clear ProxyAddresses 

#Set the new Proxys

$Users = Get-aduser -Filter * -Properties * -SearchBase "OU=CAF_Users,DC=colonyah,DC=local" 

           
foreach ($User in $Users)
            
{  
  $SAM = $User.'Samaccountname'

  $Proxy = $user.'Samaccountname' + "@" + "colonyamerican.onmicrosoftonline.com"

  Get-ADUser $SAM | Set-ADUser -Add @{ProxyAddresses="SMTP:$Proxy"} 

}


#Set SMTP

$Users = Get-aduser -Filter * -Properties * -SearchBase "OU=CAF_Users,DC=colonyah,DC=local" 

           
foreach ($User in $Users)
            
{  
  $SAM = $User.'Samaccountname'

  $Proxy = $user.'Samaccountname' + "@" + "colonyamerican.onmicrosoftonline.com"

  Get-ADUser $SAM | Set-ADUser -Add @{ProxyAddresses="SMTP:$Proxy"} 

}


#Set UPN O365

$Users = Get-aduser -Filter * -Properties * -SearchBase "OU=CAF_Users,DC=colonyah,DC=local" 
$CAFProxys = Import-Csv C:\ScriptsOutput\CAFProxy0107.csv

foreach ($CAFProxy in $CAFProxys)
{

$CAFOLD = $CAFProxy.Userprincipalname
$CAFTEMP = $CAFProxy.Userprincipalname_Temp
$CAFNEW = $CAFProxy.Userprincipalname_PostChange

Get-MsolUser -UserPrincipalName $CAFNew #Set-MsolUserPrincipalName -UserPrincipalName "$CAFTEMP"  -NewUserPrincipalName "$CAFNew"

}

#Set Single User

Set-MsolUserPrincipalName -UserPrincipalName Vurn.Saeturn@colonyamericanfinance.com -NewUserPrincipalName Vurn.Saeturn@colonyamerican.onmicrosoft.com

Set-MsolUserPrincipalName -UserPrincipalName "$OldUPN" -NewUserPrincipalName "$TempUPN" 

#Set UPN AD add smtp

$Users = Get-aduser -Filter * -Properties * -SearchBase "OU=CAF_Users,DC=colonyah,DC=local" 

foreach ($User in $Users)
{

$ename = $user.SamAccountName
$Email = "$Ename@colonyamerican.com"
$Proxy = "$Ename@colonyamerican.com"

Get-ADUser $ename | Set-ADUser -UserPrincipalName $Email -EmailAddress $Email -Add @{ProxyAddresses="smtp:$Proxy"} 

}

#Single user AD changes

$ename = "Daniel.bonsoms"
$Email = "$Ename@colonyamerican.com"
$Proxy = "$Ename@colonyamerican.com"

Get-ADUser $ename | Set-ADUser -UserPrincipalName $Email -EmailAddress $Email -Add @{ProxyAddresses="smtp:$Proxy"} 


#Create the Fucking Groups

$CAFProxys = Import-Csv C:\ScriptsOutput\CAFProxy0107.csv

foreach ($CAFProxy in $CAFProxys)
{

$CAFOLD = $CAFProxy.Userprincipalname
$CAFNEW = $CAFProxy.Userprincipalname_PostChange
$CAFGroup = $CAFProxy.GroupName


New-DistributionGroup -Name "CAFAlias - $CAFGroup" -Members $CAFNEW -PrimarySmtpAddress $CAFOLD

}


