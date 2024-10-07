# Überprüfen, ob das Skript mit Administratorrechten ausgeführt wird
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript erfordert Administratorrechte. Bitte als Administrator ausführen."
    Exit
}

# Überprüfen, ob Active Directory installiert ist
$addsFeature = Get-WindowsFeature -Name AD-Domain-Services
$adToolsFeature = Get-WindowsFeature -Name RSAT-AD-Tools

if (-not $addsFeature.Installed -and -not $adToolsFeature.Installed) {
    Write-Host "Active Directory ist nicht installiert. Es gibt nichts zu deaktivieren."
    Exit
}

# Bestätigung vom Benutzer einholen
$confirmation = Read-Host "Sind Sie sicher, dass Sie Active Directory deaktivieren und die Domäne entfernen möchten? Dies kann nicht rückgängig gemacht werden. (J/N)"
if ($confirmation -ne "J" -and $confirmation -ne "j") {
    Write-Host "Vorgang abgebrochen."
    Exit
}

# Deaktivieren von Active Directory und Entfernen der Domäne
Write-Host "Deaktiviere Active Directory und entferne die Domäne. Dies kann einige Minuten dauern..."
Import-Module ADDSDeployment
Uninstall-ADDSDomainController -DemoteOperationMasterRole:$true -ForceRemoval:$true -Force:$true

# Entfernen der Active Directory-Rolle
Write-Host "Entferne die Active Directory-Rolle..."
Uninstall-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Write-Host "Active Directory wurde erfolgreich deaktiviert und die Domäne wurde entfernt."
Write-Host "Der Server wird nun neu gestartet, um die Änderungen abzuschließen."
Restart-Computer -Force
