# Überprüfen, ob das Skript mit Administratorrechten ausgeführt wird
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript erfordert Administratorrechte. Bitte als Administrator ausführen."
    Exit
}

# Überprüfen des Status des Windows-Hypervisor-Platform Features
$hypervFeature = Get-WindowsOptionalFeature -Online -FeatureName "HypervisorPlatform"

if ($hypervFeature.State -eq "Enabled") {
    Write-Host "Das Windows-Hypervisor-Platform Feature ist bereits aktiviert."
} else {
    Write-Host "Das Windows-Hypervisor-Platform Feature wird aktiviert. Dies kann einige Minuten dauern..."
    
    Enable-WindowsOptionalFeature -Online -FeatureName "HypervisorPlatform" -NoRestart

    Write-Host "Das Windows-Hypervisor-Platform Feature wurde erfolgreich aktiviert. Ein Neustart des Systems ist erforderlich, um die Änderungen abzuschließen."
    
    $restart = Read-Host "Möchten Sie den Computer jetzt neu starten? (J/N)"
    if ($restart -eq "J" -or $restart -eq "j") {
        Restart-Computer -Force
    } else {
        Write-Host "Bitte starten Sie Ihren Computer manuell neu, um die Aktivierung des Windows-Hypervisor-Platform Features abzuschließen."
    }
}
