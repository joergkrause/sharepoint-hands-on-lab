# Admin on Server used to remote access
# Must be member of these groups if not builtin/administrator
#   Remote Desktop Users
#   WinRMRemoteWMIUsers__
#   WSS_ADMIN_WPG
#   Remote Management Users
# Import-Module ActiveDirectory
$admin = "Administrator"
if ($admin -ne "Administrator") {
    Add-ADGroupMember -Identity "Remote Desktop Users" -Members $admin
    Add-ADGroupMember -Identity "WSS_ADMIN_WPG" -Members $admin
    Add-ADGroupMember -Identity "Remote Management Users" -Members $admin
    Add-ADGroupMember -Identity "WinRMRemoteWMIUsers__" -Members $admin
}

# Server PC
$server = $env:computername;
# RM Service
set-service WinRM -computername $server -startuptype Automatic
Start-Service -Name "WinRM"
# 
Enable-PSRemoting -Force

Enable-WSManCredSSP –Role Server

winrm set winrm/config/winrs '@{MaxShellsPerUser="25"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="600"}'
# Optionally, not tested ( I think it's on the client only a requirement):
# winrm set winrm/config/service '@{AllowUnencrypted="true"}'

Write-host "This should only return all the users who have the SharePoint_Shell_Access role:"
Get-SPShellAdmin

# Add one specific Content DB
# Add-SPShellAdmin -UserName Domain\Username -Database (Get-SPContentDatabase -Identity “ContentDatabaseName”)

# Or add all Content DBs
Get-SPContentDatabase | Add-SPShellAdmin $admin

Write-host "This should return users with access:"
Get-SPShellAdmin

# This will open up a dialog box. 
write-host "Add the user(s) with Read and Execute permissions then click OK"
Set-PSSessionConfiguration -Name Microsoft.PowerShell32 –ShowSecurityDescriptorUI

