#Turn off user O365 group creation
set-OwaMailboxPolicy -GroupCreationEnabled $false -Identity OwaMailboxPolicy-Default

Get-OwaMailboxPolicy -Identity OwaMailboxPolicy-Default | Select-Object Identity, GroupCreationEnabled