#ADP Merge

Import-Module ActiveDirectory            
                
$users = Import-Csv C:\ScriptSources\ADPTest.csv   
                            
foreach ($user in $users)
 
{ 

$GivenName =  $user.GivenName 
$Surname = $user.SurName
$mgrList = $user.Managers
$mgr = get-aduser -filter {DisplayName -eq $mgrList}


Get-ADUser -Filter {(GivenName -like $GivenName ) -and (SN -like $Surname)} -Properties * -SearchBase "OU=Englewood,OU=CAH_Users,DC=Colonyah,DC=local" |
    Set-ADUser -Title "$($user.Title)" -Department "$($user.Department)" -Manager "$mgr" -Verbose 
}






##Initial Working script

$users = Import-Csv C:\ScriptSources\ADPTest.csv   
                           
$output = foreach ($user in $users)

{ 
$GivenName =  $user.GivenName 
$Surname = $user.SurName           
Get-ADUser -Filter {(GivenName -like $GivenName ) -and (SN -like $Surname)} -Properties * -SearchBase "OU=Dallas_Users,DC=Colonyah,DC=local" |
   Set-ADUser -Title "$($user.Title)" -Department "$($user.Department)" -PassThru
} $output | Out-File C:\ScriptsOutput\ADPerrors.txt -append



-Manager (get-aduser -filter "DisplayName -eq '$($user.Manager)'")


Import-Module ActiveDirectory

$users = Import-Csv C:\ScriptSources\ADPtest.csv   
                           
foreach ($user in $users) 

{
$manager = "$user.managers"
Get-ADUser -filter {Name -like "$manager"} -Properties samaccountname | Select-Object samaccountname | Export-Csv C:\ScriptSources\ADPmanagers.csv -Append

}


