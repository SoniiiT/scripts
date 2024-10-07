# Überprüfen, ob das Skript mit Administratorrechten ausgeführt wird
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript erfordert Administratorrechte. Bitte als Administrator ausführen."
    Exit
}

# Überprüfen, ob die notwendigen Windows-Funktionen installiert sind
$addsFeature = Get-WindowsFeature -Name AD-Domain-Services
$adToolsFeature = Get-WindowsFeature -Name RSAT-AD-Tools

if (-not $addsFeature.Installed -or -not $adToolsFeature.Installed) {
    Write-Host "Installation der erforderlichen Windows-Funktionen..."
    Install-WindowsFeature -Name AD-Domain-Services, RSAT-AD-Tools
}

# Konfiguration für die Active Directory-Domäne
$domainName = Read-Host "Bitte geben Sie den vollständigen Domänennamen ein (z.B. meinedomaene.local)"
$netbiosName = Read-Host "Bitte geben Sie den NetBIOS-Namen für die Domäne ein"
$safeModeAdminPassword = Read-Host "Bitte geben Sie ein sicheres Passwort für den Safe Mode Administrator ein" -AsSecureString

# Aktivieren von Active Directory und Erstellen der Domäne
Write-Host "Aktiviere Active Directory und erstelle die Domäne. Dies kann einige Minuten dauern..."
Import-Module ADDSDeployment
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName $domainName `
    -DomainNetbiosName $netbiosName `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword $safeModeAdminPassword `
    -Force:$true

Write-Host "Active Directory wurde erfolgreich aktiviert und die Domäne wurde erstellt."
Write-Host "Der Server wird nun neu gestartet, um die Änderungen abzuschließen."
