# Force a sync
Sync-DfsReplicationGroup -GroupName "American Colony Drive" -SourceComputerName "dfs01" -DestinationComputerName "DFS02" -DurationInMinutes 25 -Verbose

#Show all the connections
Get-DfsrConnection -GroupName * 

#Poll AD for Updates 

Get-DfsrMember -GroupName * | Update-DfsrConfigurationFromAD

#set up report
Start-DfsrPropagationTest -GroupName "American Colony Drive" -FolderName * -ReferenceComputerName DFS02

#Write out report

Write-DfsrPropagationReport -GroupName "American Colony Drive" -FolderName * -ReferenceComputerName DFS02 -verbose

#Get the backlog
Get-DfsrBacklog -GroupName "American Colony Drive" -FolderName * -SourceComputerName DFS01 -DestinationComputerName DFS02 -verbose

#Backlog less detail

Get-DfsrBacklog -GroupName rg01 -FolderName * -SourceComputerName srv02 -DestinationComputerName srv01 -verbose | ft FullPathName

#Count of Backlog

(Get-DfsrBacklog -GroupName "American Colony Drive" -FolderName "American Colony Drive" -SourceComputerName DFS02 -DestinationComputerName DFS01 -Verbose 4>&1).Message.Split(':')[2]

#List files currently replicating or in queue sorted with inprocess first

Get-DfsrState -ComputerName dfs01 | Sort UpdateState -descending | ft path,inbound,UpdateState,SourceComputerName -auto -wrap