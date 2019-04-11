############################################################################## 
## Reset Azure VM Admin Password   
## Arunendra Chauhan

# Define Variables

$vmName = 'myVM'
$resourceGroupName = 'myResourceGroup'
$vm = Get-AzVm -Name $vmName -ResourceGroupName $resourceGroupName
$typeHV = "2.0"

# Set credential with New password to be set
$credential = Get-Credential

# Creating Parameters
$extensionParams = @{
    'VMName' = $vmName
    'Credential' = $Credential
    'ResourceGroupName' = $resourceGroupName
    'Name' = 'AdminPasswordReset'
    'Location' = $vm.Location
    'TypeHandlerVersion' = $typeHV 
}
# Reset Admin Password
$resetPwd = Set-AzVMAccessExtension @extensionParams

If ($resetPwd.IsSuccessStatusCode -eq $true) {
# Restart VM post reset Admin Password
$vm | Restart-AzVM } 
Else { 
Write-Host "Password not reset. Check logs for details" }