
#Last reboot
systeminfo | find /i "Boot Time"

#install important updates

wuauclt.exe /detectnow /updatenow

#symantec add / remove test
A2149141

#Invoke test computer A2150991

#remotely remove Symantec

wmic product where "description='Symantec Endpoint Protection' " uninstall

#total line
wmic product where "description='Symantec Endpoint Protection' " uninstall && wuauclt.exe /detectnow /updatenow && gpupdate /force /boot


psexec \\A2167548 cmd wmic product where "description='Symantec Endpoint Protection' " uninstall

wmic product where "description='Microsoft office Professional Plus 2010' " uninstall

psexec \\A2370829 cmd wuauclt.exe /detectnow /updatenow && gpupdate /force /boot


##Get disk info

gwmi Win32_LogicalDisk | select Name, FileSystem,FreeSpace,BlockSize,Size| % {$_.BlockSize=(($_.FreeSpace)/($_.Size))*100;$_.FreeSpace=($_.FreeSpace/1GB);$_.Size=($_.Size/1GB);$_} | Format-Table Name, @{n='FS';e={$_.FileSystem}},@{n='Free, Gb';e={'{0:N2}'-f $_.FreeSpace}}, @{n='Free,%';e={'{0:N2}'-f $_.BlockSize}},@{n='Capacity ,Gb';e={'{0:N3}'-f $_.Size}} -AutoSize


#Run on dc CMD

ldifde -f export.txt -r "(Userprincipalname=*)" -l "objectGuid, userPrincipalName