﻿
$TestUsers = import-csv "C:\Scriptsoutput\testusers.csv"

foreach ($TestUser in $TestUsers)

{get-aduser -Filter "SamAccountName -eq '$($testuser.SAMAccountName)'" | Move-ADObject -TargetPath "OU=CAH_MailBox_Backup,DC=colonyah,DC=local"}

