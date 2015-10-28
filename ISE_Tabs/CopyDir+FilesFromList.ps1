$Folders = Get-Content C:\temp\FileList.txt

Foreach ($folder in $Folders)
{
ROBOCOPY "c:\SFN Docs\$folder" *_Title* c:\temp\Title
ROBOCOPY "c:\SFN Docs\$folder" *_Deed* c:\temp\Deed 
ROBOCOPY "c:\SFN Docs\$folder" *_PSA* c:\temp\PSA
ROBOCOPY "c:\SFN Docs\$folder" *_PurchasePriceAllocation* c:\temp\PPA
}
