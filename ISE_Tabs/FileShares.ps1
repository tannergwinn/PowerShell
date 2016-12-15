

#get a list of all the files

Get-ChildItem -Recurse "\\dfs02\Colony American" | ForEach-Object {$_ | add-member -name "Owner" -membertype noteproperty -value (get-acl $_.fullname).owner -passthru} | Sort-Object fullname | Select FullName,CreationTime,LastWriteTime,Length,Owner | Export-Csv -Force -NoTypeInformation C:\ScriptOutput\DFS02FilesList.csv


#date paramiter newer than 4 day (-gt) older than 4 days (-lt)
Get-ChildItem -Recurse "\\dfs02\Colony American" | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-3)} | ForEach-Object {$_ | add-member -name "Owner" -membertype noteproperty -value (get-acl $_.fullname).owner -passthru} | Select Name,CreationTime,LastWriteTime,Length,Owner | Export-Csv -Force -NoTypeInformation C:\ScriptOutput\DFS02FilesList.csv








