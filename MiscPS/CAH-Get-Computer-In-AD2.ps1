<#	
	.NOTES
	===========================================================================
	 Created on:   	3/20/2014 6:13 PM
	 Created by:   	Ron White
	 Organization: 	Colony American Homes
	 Filename:     	CAH-Get-Computers-In-AD.ps1
	 Version:     	1.0
	===========================================================================
	.DESCRIPTION
		Gets a list of all computers in the domain into an Excell workbook file
		with a date/time stamp in the file name.
#>
$Script:StartTime = Get-Date
$MyStartTime = $Script:StartTime

Clear
$Error.Clear()
Write-Host "`n`nScript started at $Script:StartTime" -ForegroundColor 'Yellow'

# Common function used to release excel objects
# Author: Sriram Reddy
# URL: http://blogs.msdn.com/b/sriram_reddy1/archive/2012/07/16/excel-with-powershell.aspx
function Release-Ref ($ref)
{
	([System.Runtime.InteropServices.Marshal]::ReleaseComObject(
	[System.__ComObject]$ref) -gt 0)
	[System.GC]::Collect()
	[System.GC]::WaitForPendingFinalizers()
}

function GetElapsedTime() {
    $runtime = $(get-date) -$MyStartTime
    $retStr = [string]::format("{0} days, {1} hours, {2} minutes, {3}.{4} seconds", `
        $runtime.Days, `
        $runtime.Hours, `
        $runtime.Minutes, `
        $runtime.Seconds, `
        $runtime.Milliseconds)
    $retStr
    }
#
# ========== MAIN ==========
#

$StartDateTime = Get-Date $Script:StartTime -Format "yyyyMMdd_HHmmss"
$OutputFile  = "CAH_AD_Computers-" + $StartDateTime + ".xlsx"

# Create filename using Documents folder and date-time stamp
$strPath = "$env:UserProfile\Documents\" + $OutputFile

Write-Host "`n`n`Getting computer list from Active Directory..." -ForegroundColor 'Yellow'
$AllADComputers = Get-ADComputer -Filter * -Properties CN, Created, LastLogonDate, LastLogonTimestamp, OperatingSystem, OperatingSystemServicePack

# Start Excel and create/open file
$objExcel         = New-Object -ComObject Excel.Application
$objExcel.Visible = $true

if (Test-Path $strPath)  
{  
	# Open the document  
	$xlWorkBook        = $objExcel.WorkBooks.Open($strPath)  
	$xlWorkBookSheet   = $xlWorkBook.Worksheets.Item(1)  
}
else
{
	# Create it
	$xlWorkBook        = $objExcel.Workbooks.Add()
	$xlWorkBookSheet   = $xlWorkBook.Worksheets.Item(1)
}

# Place header titles
$xlWorkBookSheet.Cells.Item(1,1).FormulaLocal = "ComputerName"
$xlWorkBookSheet.Cells.Item(1,2).FormulaLocal = "Created"
$xlWorkBookSheet.Cells.Item(1,3).FormulaLocal = "LastLogon"
$xlWorkBookSheet.Cells.Item(1,4).FormulaLocal = "OperatingSystem"
$xlWorkBookSheet.Cells.Item(1,5).FormulaLocal = "ServicePack"

# Set formatting for CreatedDate and LastLogonDate columns
$xlWorkBookSheet.Columns.Item(2).NumberFormat = "yyyy-mm-dd hh:mm:ss"
$xlWorkBookSheet.Columns.Item(3).NumberFormat = "yyyy-mm-dd hh:mm:ss"

$intRowMax = ($xlWorkBookSheet.UsedRange.Rows).Count
$xlLogBookSheetRow += $intRowMax + 1

$ProgressCounter   = 0
$NumberOfComputers = $AllADComputers.Count

if ($NumberOfComputers -gt 0) {
	
	foreach ($Computer in $AllADComputers) {
		
		# Show progress...
		$ProgressCounter += 1
		Write-Progress -Activity "Processing AD computer list..." -Status "processing $ProgressCounter/$NumberOfComputers AD objects..." -PercentComplete (($ProgressCounter/$NumberOfComputers) * 100)

		#Get information for current computer		
		$ComputerName    = $Computer.CN
		$CreatedDate     = Get-Date $Computer.Created -Format "yyyy-MM-dd HH:mm:ss"
		$LastLogonDate   = Get-Date $Computer.LastLogonDate -Format "yyyy-MM-dd HH:mm:ss"
		$OperatingSystem = $Computer.OperatingSystem
		$OSServicePack   = $Computer.OperatingSystemServicePack
		
		# Get next empty row
		$xlLogBookSheetRow = ($xlWorkBookSheet.UsedRange.Rows).Count + 1
		
		# Write current computer info to workbook
		$xlWorkBookSheet.Cells.Item($xlLogBookSheetRow,1).FormulaLocal = $ComputerName
		$xlWorkBookSheet.Cells.Item($xlLogBookSheetRow,2).FormulaLocal = $CreatedDate
		$xlWorkBookSheet.Cells.Item($xlLogBookSheetRow,3).FormulaLocal = $LastLogonDate
		$xlWorkBookSheet.Cells.Item($xlLogBookSheetRow,4).FormulaLocal = $OperatingSystem
		$xlWorkBookSheet.Cells.Item($xlLogBookSheetRow, 5).FormulaLocal = $OSServicePack
		
		#
		# Uncomment next line to test and debug
		# if ($ProgressCounter -eq 8) { Break }
	}
	
	# Show progess completed.
	Write-Progress -Activity "Processing AD computer list..." -Completed -Status "Completed"
	
	#
	# Save workbook
	# 
	$xlSheetUsedRange = $xlWorkBookSheet.UsedRange  
	$null = $xlSheetUsedRange.EntireColumn.AutoFit()
	
	$objExcel.ActiveSheet.ListObjects.Add(1,$objExcel.ActiveSheet.UsedRange,0,1) | Out-Null
	
	if (Test-Path $strPath)
	{  
		$objExcel.ActiveWorkBook.Save()  
	}
	else
	{  
		$objExcel.activeworkbook.SaveAs($strPath)  
		Write-Host "`n`nSaved AD computers information to: " $strPath -ForegroundColor 'Cyan'
	}
	
}


#
# Close Excel files and clean up
#
#===============================================================================

$xlWorkBook.Close()

$a = Release-Ref($xlWorkBookSheet)
$a = Release-Ref($xlSheetUsedRange)
$a = Release-Ref($xlWorkBook)

# Display script execution time
$StartTime = Get-Date $Script:StartTime -Format "yyyy-MM-dd HH:mm:ss"
$EndTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
#$TotalElapsedTime = $(get-date) - $MyStartTime
#$RunTime   = $(Get-Date) - $StartTime

Write-Host "`n`n"
Write-Host "Script Started at $StartTime"
Write-Host "Script Ended at $EndTime"
write-Host "Total Elapsed Time: $(GetElapsedTime)"
Write-Host "`n`n"

# Quit Excel

$objExcel.Quit()
$a = Release-Ref($objExcel)
$null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($objExcel)
[GC]::Collect()

#===============================================================================