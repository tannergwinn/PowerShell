#GPO PS

#Get-GPO's
Get-GPO -All | Export-Csv C:\ScriptOutput\GPO_All.csv

#Bulk set permissions in bulk - updates existing structure

$GPOs = Import-Csv C:\ScriptSources\PrintGPOs.csv

foreach ($GPO in $GPOS)
{

Set-GPPermissions -Guid $GPO.ID -TargetName "Level_1" -TargetType Group -PermissionLevel GpoEdit 
}




