#Utilize O365 eDiscovery over PowerShell

New-MailboxSearch "Discovery-CaseBrianL" -StartDate "6/1/2015" -EndDate "07/23/2015" -SearchQuery '"To:brianleakeas@kw.com"' -MessageTypes Email -IncludeUnsearchableItems -LogLevel Full