Break

#Inactive items

Search-ADAccount -accountinactive -ComputersOnly | Export-Csv c:\temp\OutdatedComputers.csv


# 2 ways to get same data
Get-WmiObject -Class win_32_bios -ComputerName (Get-ADComputer -filter * ).name

Get-ADComputer -Filter * | Get-WmiObject win_32_bios -ComputerName {$_.Name}

#Connect via PS

Enter-PSSession -ComputerName 