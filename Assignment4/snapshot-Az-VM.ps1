############################################################################## 
## Create Snapshot of a vm under a resourcegroup
## Arunendra Chauhan 

# All resource groups
$RG_All = Write-Host ((Get-AzResourceGroup).ResourceGroupName)
# Enter desired RG Name
$resourceGroupName = Read-Host -Prompt "Enter desired RG name "
$resourceGroupName
$location = (Get-AzResourceGroup -Name $resourceGroupName).Location 
# Get all VMs in given RG

$VMs = (Get-AzVM -ResourceGroupName $resourceGroupName).Name
$vmName = Read-Host "Enter desired VM name"
$vmName
$snapshotName = $VMName + "_snapshot" 

$vm = get-azvm -ResourceGroupName $resourceGroupName -Name $vmName

Function snapshot($vmName) {
$snapshot =  New-AzSnapshotConfig `
-SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
-Location $location -CreateOption copy


$createSnapShot = New-AzSnapshot -Snapshot $snapshot -SnapshotName $snapshotName `
-ResourceGroupName $resourceGroupName

Write-Output "snapshot has been created"

}

snapshot($vmName)


