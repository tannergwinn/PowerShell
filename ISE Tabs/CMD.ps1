
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