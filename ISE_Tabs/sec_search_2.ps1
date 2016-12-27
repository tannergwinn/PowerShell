# This script, created by Jason Weitzman, should search the egnyte local storage and find documents fitting the following critera

# 1: document must be a lease

# 2: document must be in a folder with the matching address from CSV.



#path vars

$CSVPath = "\\10.1.103.10\Users\Public\Documents\Dropbox\wpscripting\OSN (09-18-2014) codeOnly.csv";

$SearchDir = "\\10.1.50.50\Capital_Markets\Due Dili\SWAY StructuredFN\Uploads in SFN";

$DestDir = "\\10.1.50.50\Capital_Markets\Securities Results";



#Import CSV

$Codes = Get-Content $CSVPath;



#Iterate through CSV lines and perform searc/copy of all lease pdf files found with the same address.

Foreach ($Code in $Codes){

write-output "`nCode from CSV = $Code" >> $DestDir\log.txt;

write-host "`nCode from CSV = $Code";

Get-ChildItem $SearchDir\* -recurse -filter *$Code* -Include "*lease*.pdf","*ts receipt*.pdf","*bid receipt*.pdf","*deed as pop*.pdf","*final statement*.pdf","*purchagree*.pdf" | Copy-Item -Destination $DestDir;

}
