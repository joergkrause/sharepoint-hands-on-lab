Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

Write-Host "Loading SnapIn:`n"
Add-PSSnapin Microsoft.SharePoint.PowerShell
Write-Host "Disabling Services:`n"
$version = (Get-SPFarm).BuildVersion.Major
if ($version -eq 15) {
$tokill = @("SearchRuntimeService Name=SPSearchHostController",
    "AppManagementService",
    "AccessServicesWebService",
    "BdcService",
    "SPRequestManagementService",
    "SecureStoreService",
    "SPWindowsTokenService Name=c2wts",
    "SPWorkflowTimerService Name=spworkflowtimerv4",
    "BIMonitoringService",
    "SPUserCodeService Name=SPUserCodeV4",
    "VisioGraphicsService",
    "LauncherService Name=DCLauncher15",
    "LoadBalancerService Name=DCLoadBalancer15",
    "WorkManagementService",
    "ExcelServerWebService",
    "SPIncomingEmailService",
    "AccessServerWebService",
    "NotesWebService",
    "WordService",
    "PowerPointConversionService",
    "TranslationService",
    "SPDistributedCacheService Name=AppFabricCachingService")
}
if ($version -eq 16) {
$tokill = @("SearchRuntimeService Name=SPSearchHostController",
    "AppManagementService",
    "AccessServicesWebService",
    "BdcService",
    "SPRequestManagementService",
    "SecureStoreService",
    "SPWindowsTokenService Name=c2wts",
    "SPWorkflowTimerService Name=spworkflowtimerv4",
    "BIMonitoringService",
    "SPUserCodeService Name=SPUserCodeV4",
    "VisioGraphicsService",
    "LauncherService Name=DCLauncher16",
    "LoadBalancerService Name=DCLoadBalancer16",
    "SPIncomingEmailService",
    "AccessServerWebService",
    "NotesWebService",
    "WordService",
    "PowerPointConversionService",
    "TranslationService",
    "SPDistributedCacheService Name=AppFabricCachingService")
}
foreach($element in $tokill) {
    Write-Host "$element `n"
    $instanceName = $element 
    $serviceInstance = Get-SPServiceInstance | ? {($_.service.tostring()) -eq $instanceName -and ($_.server.name) -eq $env:computername} 
    $serviceInstance.Unprovision()
}