﻿wmic product where "description='Symantec Endpoint Protection' " uninstall && wuauclt.exe /detectnow /updatenow && gpupdate /force\

Jaminwhit11