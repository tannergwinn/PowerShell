#################################################
# O365 Group settings company wide
#
#################################################

#Connect
$msolcred = get-credential
connect-msolservice -credential $msolcred


#Settings template for allowing group creation

$template = Get-MsolAllSettingTemplate | where-object {$_.displayname -eq "Group.Unified"}
$setting = $template.CreateSettingsObject()
$setting.Values
$setting["EnableGroupCreation"] = "false"

$setting["GroupCreationAllowedGroupId"] = "8003e941-6239-4f5c-be1c-d8e1d8ca9278" 

New-MsolSettings -SettingsObject $setting

