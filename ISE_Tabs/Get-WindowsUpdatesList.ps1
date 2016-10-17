#Get all installed updates and export
Get-WmiObject -Class "win32_quickfixengineering" |
Select-Object -Property "Description", "HotfixID", 

@{Name="InstalledOn"; Expression={([DateTime]($_.InstalledOn)).ToLocalTime()}} | Sort-Object -property "InstalledOn" -Descending | Out-File C:\Users\a.hart\Desktop\$(hostname).$((Get-Date).ToString('MM-dd-yyyy')).txt