$Folders = Get-Content C:\temp\FileList.txt

Foreach ($folder in $Folders)
{
ROBOCOPY c:\ScriptSources\$folder c:\temp\$folder
}
