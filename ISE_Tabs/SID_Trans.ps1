#Script written by Jason Weitzman 07/20/2016.
#This script will translate to and from Security ID

$Conv_Type = Read-Host -Prompt 'Please choose a conversion type
    1) Convert SID to Domain User Name
    2) Convert Domain User Name to SID
    3) Convert Local User to SID
    Type'

    if ($Conv_Type -eq 1) {
        $SID = Read-Host - Prompt 'What is the SID?'
        Get_User $SID
        } 
        elseif ($Conv_Type -eq 2) {
            $DName = Read-Host -Prompt 'What is the Domain Name?'
            $UName = Read-Host -Prompt 'What is the User Name?'
            Get_Domain_User_SID $DName $UName
            }
        elseif ($Conv_Type-eq 3) {
            $LocalUName = ([Environment]::UserName)
            Get_Local_SID $LocalUName
            }

function Get_User($SID){
#This will allow you to enter a SID and find the Domain User
$objSID = New-Object System.Security.Principal.SecurityIdentifier ($SID) 
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount]) 
$objUser.Value
}

function Get_Domain_User_SID($DName, $UName){
#This will give you a Domain User's SID
$objUser = New-Object System.Security.Principal.NTAccount($DName, $UName) 
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]) 
$strSID.Value
}

function Get_Local_SID($LocalUName){
#This will allow you to find the SID of the local user
$objUser = New-Object System.Security.Principal.NTAccount($LocalUName) 
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]) 
$strSID.Value
}