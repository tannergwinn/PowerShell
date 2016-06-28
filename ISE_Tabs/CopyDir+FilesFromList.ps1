$Folders = Get-Content C:\temp\FileList.txt

Foreach ($folder in $Folders)
{
ROBOCOPY "c:\SFN Docs\$folder" *_Title* c:\temp\Title
ROBOCOPY "c:\SFN Docs\$folder" *_Deed* c:\temp\Deed 
ROBOCOPY "c:\SFN Docs\$folder" *_PSA* c:\temp\PSA
ROBOCOPY "c:\SFN Docs\$folder" *_PurchasePriceAllocation* c:\temp\PPA
}


#Wells Fargo Doc pull 

#Old Script
 $Folders = Get-Content C:\temp\FileList.txt

Foreach ($folder in $Folders)
{
ROBOCOPY "c:\SFN Docs\$folder" ​*_Title*​ c:\temp\Title
ROBOCOPY "c:\SFN Docs\$folder" ​*_Deed*​ c:\temp\Deed 
ROBOCOPY "c:\SFN Docs\$folder" ​*_PSA*​ c:\temp\PSA
ROBOCOPY "c:\SFN Docs\$folder" ​*_HUD*​ c:\temp\PPA
ROBOCOPY "c:\SFN Docs\$folder" ​*_BidReceipt*​ c:\temp\PPA
}

#Failed
$Folders = import-csv C:\ScriptSources\Testwellsdocpull.csv

Foreach ($folder in $Folders)
{
$folderInfo = "$folder.path"

ROBOCOPY /CREATE $folderInfo ​*_Title*​ "C:\Users\a.hart\Desktop\Test\$Folder.PropInfo" /CREATE
#ROBOCOPY "$folder" ​*_Deed*​ "D:\WFLoan\Test\$Folder.PropInfo"
#ROBOCOPY "$folder" ​*_PSA*​ "D:\WFLoan\Test\$Folder.PropInfo"
#ROBOCOPY "$folder" ​*_HUD*​ "D:\WFLoan\Test\$Folder.PropInfo"
#ROBOCOPY "$folder" ​*_Bid*​ "D:\WFLoan\Test\$Folder.PropInfo"
}