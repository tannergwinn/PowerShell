cd Z:\Storage\Scripts\"ISE Tabs"

. .\Get-LastLogon.ps1

$Computers = Get-Content "C:\ScriptSources\Computers.txt"

Get-LastLogon -ComputerName $Computers | out-file "C:\ScriptsOutput\Computers.txt"