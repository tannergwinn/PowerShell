$PropIDs = Get-Content C:\Input\PropIDs.txt

ForEach ($propID in $PropIDs)

{Get-ChildItem 'G:\SWAY Syndicate Title\4a. Clean Title Policies' -Filter *$propID* -Recurse | Select-Object Name | Export-Csv C:\Output\Results.csv -Append }