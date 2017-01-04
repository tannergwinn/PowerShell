#################################
#Client Requirements:
#File names containing: title, commitment, policy for 800+ properties
#Search Location 1: I:/ Acquisitions/ _Georgia
#SearchLocation 2: I:/ Acquisitions/ SWAY Acquisition Documents
#Destination Location: I:\16. Dispositions\___(Externally Shared) Portfolio Diligence\PragerGroupGA\Titles, Commitments, Policies
#Tasks:
#Get working directory list or the properties
#Edit script to match key words and output configuration
#################################


#path vars

$CSVPath = "C:\ScriptSources\GA859PropertyListSource3_p.csv";

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

