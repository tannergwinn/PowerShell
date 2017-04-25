## SQL Server Powershell Commands
## KB Site: https://dbatools.io/functions/export-sqluser/
## Install command: Invoke-Expression (Invoke-WebRequest -UseBasicParsing https://dbatools.io/in)
##
#################################################################################################
##Connect to SSMS as user other than logged in - May require entry in windows cred manager 
runas /netonly /user:domain\username ssms.exe


#Export list of permissions
Export-SqlUser -SqlInstance SQLPRD -database CAH_Portal -FilePath C:\ScriptOutput\SQLPRD_Users.sql 