#get a list of all the files
Get-ChildItem -Recurse "\\dfs02\Colony American" | ForEach-Object {$_ | add-member -name "Owner" -membertype noteproperty -value (get-acl $_.fullname).owner -passthru} | Sort-Object fullname | Select FullName,CreationTime,LastWriteTime,Length,Owner | Export-Csv -Force -NoTypeInformation C:\ScriptOutput\DFS02FilesList.csv


#date paramiter newer than 4 day (-gt) older than 4 days (-lt)
Get-ChildItem -Recurse "\\dfs02\Colony American" |
 Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-3)} |
  ForEach-Object {$_ | add-member -name "Owner" -membertype noteproperty -value (get-acl $_.fullname).owner -passthru} |
   Select Name,CreationTime,LastWriteTime,Length,Owner |
    Export-Csv -Force -NoTypeInformation C:\ScriptOutput\DFS02FilesList.csv


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


Get-ChildItem -Path E:\music -Filter *.mp3 -Recurse | Select-Object directoryname, basename, length

#Get list of applicable directories

$PropsList = Import-Csv C:\ScriptSources\GA859PropertyListSource.csv

foreach ($PL in $PropsList)

{

$propID = $PL.PropertyID

Get-ChildItem -Filter {Fullname -like '*$PropID*'}  -Recurse | ?{ $_.PSIsContainer } | Select-Object FullName
}

Get-ChildItem -dir -Filter {Fullname -like '*1017fore*'} -Recurse | ?{ $_.PSIsContainer } | Select-Object FullName



#############SOURCE SCRIPT#############

##John Price

$Folders = Get-Content D:\WFLoan\ScriptTest.csv

Foreach ($folder in $Folders)
{
ROBOCOPY "$folder" *_Title* "D:\WFLoan\Test\$Folder"
ROBOCOPY "$folder" *_Deed* "D:\WFLoan\Test\$Folder"
ROBOCOPY "$folder" *_PSA* "D:\WFLoan\Test\$Folder"
ROBOCOPY "$folder" *_HUD* "D:\WFLoan\Test\$Folder"
ROBOCOPY "$folder" *_Bid* "D:\WFLoan\Test\$Folder"
}

##[10:34 AM]  Ariel Hart #New Script
$Folders = import-csv D:\WFLoan\ScriptTest.csv

Foreach ($folder in $Folders)
{
ROBOCOPY "$folder" *_Title* "D:\WFLoan\Test\$Folder.PropInfo"
ROBOCOPY "$folder" *_Deed* "D:\WFLoan\Test\$Folder.PropInfo"
ROBOCOPY "$folder" *_PSA* "D:\WFLoan\Test\$Folder.PropInfo"
ROBOCOPY "$folder" *_HUD* "D:\WFLoan\Test\$Folder.PropInfo"
ROBOCOPY "$folder" *_Bid* "D:\WFLoan\Test\$Folder.PropInfo"
}








