# Überprüfen, ob das Skript mit Administratorrechten ausgeführt wird
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript erfordert Administratorrechte. Bitte als Administrator ausführen."
    Exit
}

# Importieren des Hyper-V-Moduls
Import-Module Hyper-V

# Abfrage des Clusternamens
$clusterName = Read-Host "Bitte geben Sie den Namen des Ziel-Clusters ein"

# Abrufen aller lokalen VMs
$localVMs = Get-VM | Where-Object { $_.ComputerName -eq $env:COMPUTERNAME }

foreach ($vm in $localVMs) {
    Write-Host "Migriere VM: $($vm.Name) zum Cluster: $clusterName"
    
    try {
        # Stoppen der VM, falls sie läuft
        if ($vm.State -eq 'Running') {
            Stop-VM -Name $vm.Name -Force
        }
        
        # Migration der VM zum Cluster
        Move-VMToCluster -VMName $vm.Name -DestinationCluster $clusterName -IncludeStorage
        
        Write-Host "VM $($vm.Name) wurde erfolgreich zum Cluster migriert."
    }
    catch {
        Write-Error "Fehler bei der Migration von VM $($vm.Name): $_"
    }
}

Write-Host "Migration aller lokalen VMs zum Cluster $clusterName abgeschlossen."
