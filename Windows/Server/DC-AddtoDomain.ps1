# Überprüfen, ob das Skript mit Administratorrechten ausgeführt wird
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript erfordert Administratorrechte. Bitte als Administrator ausführen."
    Exit
}

# Installation der Active Directory-Rolle
Write-Host "Installiere die Active Directory-Rolle..."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Abfrage der Domäneninformationen
$domainName = Read-Host "Bitte geben Sie den vollständigen Domänennamen ein (z.B. meinedomaene.local)"
$username = Read-Host "Bitte geben Sie den Benutzernamen eines Domänenadministrators ein"
$password = Read-Host "Bitte geben Sie das Passwort des Domänenadministrators ein" -AsSecureString

# Beitritt zur Domäne
Write-Host "Trete der Domäne bei. Dies kann einige Minuten dauern..."
Add-Computer -DomainName $domainName -Credential (New-Object System.Management.Automation.PSCredential ($username, $password)) -Restart -Force

Write-Host "Der Computer wurde erfolgreich der Domäne hinzugefügt. Der Computer wird nun neu gestartet, um die Änderungen abzuschließen."
