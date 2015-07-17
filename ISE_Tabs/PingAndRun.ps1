$Symantec = get-content C:\ScriptSources\Symantec0625.txt


Foreach ($Sym in $Symantec)

{

if(!(Test-Connection -Cn $Sym -BufferSize 16 -Count 1 -ea 0 -quiet))


{
"$Sym Not Online"
}

Else {wmic /node:$sym product where "description='Symantec Endpoint Protection' " uninstall}#EndIF

}#EndForEach

