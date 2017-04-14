Break

##Skype for Business

$credential = Get-Credential
Import-Module SkypeOnlineConnector
$sfboSession = New-CsOnlineSession -Credential $credential
Import-PSSession $sfboSession

Get-CsTenant | Select-Object DisplayName, TenantID