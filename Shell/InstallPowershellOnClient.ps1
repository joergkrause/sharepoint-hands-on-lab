# Step 1: Launch “Local Group Policy user interface”  by typing gpedit.msc  in the run promput.
# Step 2: Navigate to “Local Computer Policy > Computer Configuration > Administrative Templates > Windows Components > Windows Remote Management (WinRM) > WinRM Client”.
# Step 3: Enable “Allow unencrypted traffic”


Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

$server = "ec2-18-194-237-57.eu-central-1.compute.amazonaws.com"
$admin = "Administrator"
# Client PC
$client = $env:computername;
# RM Service
Set-Service WinRM -computername $client -startuptype Automatic
Start-Service -Name "WinRM"

Write-Host "Checking outbound rules:"
################################
# If AD has KERBEROS
################################
$kerb = Get-WSManCredSSP | Select-String -Pattern "wsman/$server" 
if ($kerb.length -lt 1 -or $kerb.Line.Length -lt 10) { 
    Write-Host "No rule found, add one"
    # Kerberos only
    Enable-WSManCredSSP -Role client -DelegateComputer "$server"    
}
################################
# If AD has NTLM
################################
# assuming we check the first one only
$ntml = (Get-ItemProperty -path "HKLM:Software\Policies\Microsoft\Windows\CredentialsDelegation\AllowFreshCredentialsWhenNTLMOnly").1
if ($ntlm -ne "wsman/$server") {
    # NTLM
    # Local Group Policies Editor -> Computer Configuration -> Administrative Templates -> System -> Credentials Delegation -> Allow Delegating Fresh Credentials with NTLM-only Server Authentication
    # We put this on pos one, whether or not it exists, this is a bit harsh, though
    Set-ItemProperty -Path. -Name 1 -Value "wsman/$server"
}

################################
# Fully automated with password in the file in clear text
################################
$password = ConvertTo-SecureString "sharepoint?2018" -AsPlainText -Force
#$secstr = New-Object -TypeName System.Security.SecureString
#$password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
#$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secstr

################################
# interactive with asking for password all the time
################################
Write-Host "Enter the credentials of the user logged onto the client machine:"
$cred = Get-Credential -UserName $admin -Message "Please enter the server Admin's password"

$s = New-PSsession $server -authentication credssp -credential $cred

# Some commands to access server
Invoke-Command -Session $s -ScriptBlock {Add-PSSnapin Microsoft.SharePoint.PowerShell;}
Invoke-Command -Session $s -ScriptBlock {Get-SPContentDatabase}
Invoke-Command -Session $s -ScriptBlock {Get-SPServiceInstance}

# Open session for interaction
Enter-PSSession -session $s

# On the shell activate SharePoint
Add-PSSnapin Microsoft.SharePoint.PowerShell
