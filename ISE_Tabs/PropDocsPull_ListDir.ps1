$CSVPath = "C:\ScriptSources\GA859PropertyListSource2.csv";

$SearchDir = "I:\Acquisitions\_Georgia";

$DestDir = "I:\16. Dispositions\___(Externally Shared) Portfolio Diligence\PragerGroupGA\Titles, Commitments, Policies";


#Import CSV

$Codes = Get-Content $CSVPath;


#Iterate through CSV lines and perform searc/copy of all lease pdf files found with the same address.

Foreach ($Code in $Codes){

write-output "`nCode from CSV = $Code" >> $DestDir\GA859PropertyListSource3_p-log.txt;

write-host "`nCode from CSV = $Code";

Get-ChildItem $SearchDir\* -recurse -filter *$Code* -Include "*title*.pdf","*commitment*.pdf","*policy*.pdf" | Copy-Item -Destination $DestDir;

}