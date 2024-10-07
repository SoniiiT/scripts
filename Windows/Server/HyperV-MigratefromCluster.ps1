# Überprüfen, ob das Skript mit Administratorrechten ausgeführt wird
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript erfordert Administratorrechte. Bitte als Administrator ausführen."
    Exit
}

# Importieren des Hyper-V-Moduls
Import-Module Hyper-V

# Abfrage des Clusternamens
$clusterName = Read-Host "Bitte geben Sie den Namen des Quell-Clusters ein"

# Abfrage des Ziel-Hyper-V-Hosts
$targetHost = Read-Host "Bitte geben Sie den Namen des Ziel-Hyper-V-Hosts ein"

# Abrufen aller VMs im Cluster
$clusterVMs = Get-ClusterResource | Where-Object { $_.ResourceType -eq "Virtual Machine" } | ForEach-Object { Get-VM -Name $_.OwnerGroup }

foreach ($vm in $clusterVMs) {
    Write-Host "Migriere VM: $($vm.Name) vom Cluster: $clusterName zum Hyper-V-Host: $targetHost"
    
    try {
        # Stoppen der VM, falls sie läuft
        if ($vm.State -eq 'Running') {
            Stop-VM -Name $vm.Name -Force
        }
        
        # Migration der VM vom Cluster zum Hyper-V-Host
        Move-VM -Name $vm.Name -DestinationHost $targetHost -IncludeStorage
        
        Write-Host "VM $($vm.Name) wurde erfolgreich zum Hyper-V-Host migriert."
    }
    catch {
        Write-Error "Fehler bei der Migration von VM $($vm.Name): $_"
    }
}

Write-Host "Migration aller VMs vom Cluster $clusterName zum Hyper-V-Host $targetHost abgeschlossen."
