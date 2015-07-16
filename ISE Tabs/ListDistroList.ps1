################################################################################################################################################################
# Script accepts 2 parameters from the command line
#
# Office365Username - Mandatory - Administrator login ID for the tenant we are querying
# Office365Password - Mandatory - Administrator login password for the tenant we are querying
#
#
# To run the script
#
# .\Get-DistributionGroupMembers.ps1 -Office365Username admin@xxxxxx.onmicrosoft.com -Office365Password Password123 
#
################################################################################################################################################################

#Accept input parameters
Param(
	[Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [string] $Office365Username,
	[Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true)]
    [string] $Office365Password
)

#Constant Variables

#Main
Function Main {

	#Remove all existing Powershell sessions
	Get-PSSession | Remove-PSSession
	
	#Call ConnectTo-ExchangeOnline function with correct credentials
	ConnectTo-ExchangeOnline -Office365AdminUsername $Office365Username -Office365AdminPassword $Office365Password
	
	# Create filename using Documents folder and date-time stamp
	$StartDateTime = Get-Date $Script:StartTime -Format "yyyyMMdd_HHmmss"
	$OutputFile = "DistributionGroupMembers-" + $StartDateTime + ".xlsx"
	$strDGWorkbook = "$env:UserProfile\Documents\" + $OutputFile
	
	$objExcel = New-Object -ComObject Excel.Application
	$objExcel.Visible = $true
	
	#
	# Create DG members workbook
	#
	$xlDGBook = $objExcel.Workbooks.Add()
	$xlDGBookSheet = $xlDGBook.Worksheets.Item(1)
	
	$xlDGBookSheet.Cells.Item(1, 1).FormulaLocal = "DG"
	$xlDGBookSheet.Cells.Item(1, 2).FormulaLocal = "Member"
	$xlDGBookSheet.Cells.Item(1, 3).FormulaLocal = "Email Address"
		
	$xlDGBookSheetRow = (($xlDGBookSheet.UsedRange.Rows).Count) + 1
	
	#Get all Distribution Groups from Office 365
	$objDistributionGroups = Get-DistributionGroup -ResultSize Unlimited
	
	#Iterate through all groups, one at a time	
	Foreach ($objDistributionGroup in $objDistributionGroups)
	{	
		
		write-host "Processing $($objDistributionGroup.DisplayName)..."
		$strDGDisplayName = $objDistributionGroup.DisplayName
		
		#Get members of this group
		$objDGMembers = Get-DistributionGroupMember -Identity $($objDistributionGroup.PrimarySmtpAddress)
		
		write-host "Found $($objDGMembers.Count) members..."
		
		#Iterate through each member
		Foreach ($objMember in $objDGMembers)
		{
			write-host "Processing member: $($objMember.PrimarySmtpAddress)"
			
			#If it is a nested DG, ignore it
			if ($($objMember.RecipientType) -like "*DistributionGroup*")
			{
				write-host "`tMember is another DL"
			}
			else
			{
				write-host "`tMember is a user..."
				$xlDGBookSheetRow = (($xlDGBookSheet.UsedRange.Rows).Count) + 1
				$xlDGBookSheet.Cells.Item($xlDGBookSheetRow, 1).FormulaLocal = $strDGDisplayName
				$xlDGBookSheet.Cells.Item($xlDGBookSheetRow, 2).FormulaLocal = $objMember.Name
				$xlDGBookSheet.Cells.Item($xlDGBookSheetRow, 3).FormulaLocal = $objMember.PrimarySmtpAddress
			}
		}
	}
	
	$xlDGBook.Activate()
	$xlSheetUsedRange = $xlDGBookSheet.UsedRange
	$null = $xlSheetUsedRange.EntireColumn.AutoFit()
	$objExcel.ActiveWorkbook.SaveAs($strDGWorkbook)
	
	#
	# Close Excel files and clean up
	#
	
	$xlDGBook.Close()
	
	$a = Release-Ref($xlDGBookSheet)
	$a = Release-Ref($xlSheetUsedRange)
	$a = Release-Ref($xlDGBook)
	
	$objExcel.Quit()
	
	$a = Release-Ref($objExcel)
	
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($objExcel)
	[GC]::Collect()
	
	#Clean up session
	Get-PSSession | Remove-PSSession
}

###############################################################################
#
# Function ConnectTo-ExchangeOnline
#
# PURPOSE
#    Connects to Exchange Online Remote PowerShell using the tenant credentials
#
# INPUT
#    Tenant Admin username and password.
#
# RETURN
#    None.
#
###############################################################################
function ConnectTo-ExchangeOnline
{   
	Param( 
		[Parameter(
		Mandatory=$true,
		Position=0)]
		[String]$Office365AdminUsername,
		[Parameter(
		Mandatory=$true,
		Position=1)]
		[String]$Office365AdminPassword

    )
		
	#Encrypt password for transmission to Office365
	$SecureOffice365Password = ConvertTo-SecureString -AsPlainText $Office365AdminPassword -Force    
	
	#Build credentials object
	$Office365Credentials  = New-Object System.Management.Automation.PSCredential $Office365AdminUsername, $SecureOffice365Password
	
	#Create remote Powershell session
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $Office365credentials -Authentication Basic –AllowRedirection    	

	#Import the session
    Import-PSSession $Session -AllowClobber | Out-Null
}

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
# Start script
. Main