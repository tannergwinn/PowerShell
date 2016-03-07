cd Z:\Storage\Scripts\Powershell\ISE_Tabs

. .\Get-LastLogon.ps1

Get-ADComputer -filter * -Properties Name -SearchBase "OU=CAH_Computers,DC=colonyah,DC=local" |Select-Object Name |Export-csv C:\Scriptsources\computers.csv

$Computers = import-csv "C:\ScriptSources\Computers.csv"

Get-LastLogon -ComputerName $Computers #| Export-csv "C:\ScriptsOutput\Computers.csv" -append