#GPO Powershell

#Get-GPO's List
Get-GPO -All | Export-Csv C:\ScriptOutput\GPO_All.csv

#Bulk set permissions - updates existing structure

$GPOs = Import-Csv C:\ScriptSources\PrintGPOs.csv

foreach ($GPO in $GPOS)
{

Set-GPPermissions -Guid $GPO.ID -TargetName "Level_1" -TargetType Group -PermissionLevel GpoEdit 
}




