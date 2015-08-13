Get-ADOrganizationalUnit -filter * -SearchBase 'OU=CAH_Users,DC=colonyah,DC=local' |

foreach {

  $users=Get-ADUser -filter * -searchbase $_.distinguishedname -ResultPageSize 2000 -resultSetSize 500 -searchscope Onelevel 

  $total=($users | measure-object).count

  New-Object psobject -Property @{

    OU=$_.Name;

    Brugere=$Total

    }

} | Export-Csv C:\ScriptsOutput\UserCount.csv