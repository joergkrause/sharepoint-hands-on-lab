Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
# Provide the name of the service to toggle off of.
# This service will be used to decide startup/shutdown actions.
cls
# Provide the name of the service to toggle off of.
# This service will be used to decide startup/shutdown actions.
$keySvc = Get-Service 'MSSQLSERVER'
# Single quote SQL instance names so that $SHAREPOINT is not interpreted

Write-Host "Key Service:`n"
Write-Host $keySvc

$version = (Get-SPFarm).BuildVersion.Major
Write-Host "Running Sharepoint v$version"

# Include each service name to be managed, and its startup type.
# Services will be stopped/disabled in the order listed
# and started in the reverse order listed.
if ($version -eq 15) {
    $spSvcs +=  'DCLoadBalancer15','Manual'
    $spSvcs +=  'DCLauncher15','Manual'
    $spSvcs +=  'OSearch15','Manual'
}
if ($version -eq 16) {
    $spSvcs +=  'DCLoadBalancer16','Manual'
    $spSvcs +=  'DCLauncher16','Manual'
    $spSvcs +=  'OSearch16','Manual'
}
$spSvcs +=  'SPSearchHostController','Automatic'
$spSvcs +=  'SPUserCodeV4','Automatic'
$spSvcs +=  'SPTimerV4','Automatic'
$spSvcs +=  'SPTraceV4','Automatic'
$spSvcs +=  'c2wts','Automatic'
$spSvcs +=  'SQLWriter','Automatic'
$spSvcs +=  'WorkflowServiceBackend','Automatic'
$spSvcs +=  'Service Bus Gateway','Automatic (Delayed Start)'
$spSvcs +=  'Service Bus Message Broker','Automatic (Delayed Start)'
$spSvcs +=  'Service Bus Resource Provider','Automatic (Delayed Start)'
$spSvcs +=  'Service Bus VSS','Automatic'

# The keying service should be the last to stop and the first to start.
# $spSvcs +=  $keySvc.Name,'Automatic'
            

# Detecting current status of environment.
# Keys off of status of SQL Server...
Write-Host "Checking current status..."

Write-Host $keySvcs.Name "is currently" $keySvc.Status

$name = Read-Host 'Start or Stop Services? (Start=T, Stop=S)'

if ($name.ToLowerInvariant() -eq "s")
    { 
        write-host "Service appear started... stopping..."
        # Stop all services
        $i = 0
        While ($i -lt $spSvcs.Count)
        {
            write-host "Checking "  $spSvcs[$i]
            if ((Get-Service OSearch16 -ErrorAction SilentlyContinue).Status -eq "Running") {
                write-host "Stopping "  $spSvcs[$i]
                Stop-Service $spSvcs[$i] -force
                write-host "Disabling " $spSvcs[$i]
                Set-Service $spSvcs[$i] -StartupType "Disabled"
                # Skip 2 because startup type isn't relevant
            }
            $i = $i + 2
        }
     }
Else
    {
        write-host "Service appear stopped... starting..."
        $i = $spSvcs.Count - 1
        While ($i -ge 0)
        {
            if ((Get-Service OSearch16 -ErrorAction SilentlyContinue).Status -eq "Stopped") {       
                #Get-Service $spSvcs[$i-1]
                write-host "Setting " $spSvcs[$i-1] " to " $spSvcs[$i] " startup"
                Set-Service $spSvcs[$i-1] -StartupType $spSvcs[$i]
                Write-Host "Starting "$spSvcs[$i-1]
                Start-Service $spSvcs[$i-1]
            }
            $i = $i - 2
        }        
    }
    
Write-Host 'Finished.'
Pause

