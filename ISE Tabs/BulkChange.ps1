#Change users Title and Department from CSV Bulk

Import-Module ActiveDirectory            
                
$users = Import-Csv -Path C:\ScriptSources\SAMName3.csv                      
            
$output = foreach ($user in $users)

{            
Get-ADUser -Filter "SamAccountName -eq '$($user.SAMAccountName)'" -Properties * -SearchBase "DC=Colonyah,DC=local" |
    Set-ADUser -Title "$($user.Title)" -Department "$($user.Department)"
} $output | Out-File C:\ScriptsOutput\errors.txt -append
 

Get-ADUser -Filter 'enabled -eq $true' -Properties DisplayName, SAMAccountName | Select-Object DisplayName, SAMAccountName | Export-Csv C:\ScriptSources\SAMName2.csv

Start-Transcript -path c:\docs\Text3.txt


Import-Module ActiveDirectory            
                
$users = Import-Csv -Path C:\ScriptSources\SAMName3.csv                      

foreach ($user in $users)

{            
Get-ADUser -Filter "SamAccountName -eq '$($user.SAMAccountName)'" -Properties * -SearchBase "DC=Colonyah,DC=local" |
    Set-ADUser -Title "$($user.Title)" -Department "$($user.Department)" -verbose -PassThru -EA stop
}
