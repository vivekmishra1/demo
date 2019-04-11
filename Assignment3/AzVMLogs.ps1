############################################################################## 
## Azure VMs log 
## Arunendra Chauhan 

$RGName = "myResourceGroup"
$SubscritionID = (Get-AzSubscription).Id
$ProviderName = "Microsoft.Compute/virtualMachines"
$VMs = (Get-Azvm).Name
$VMs | ForEach-Object {
$Output = Get-AzLog -ResourceId `
 "/subscriptions/$SubscritionID/resourceGroups/$RGName/providers/$ProviderName/$_" `
 -StartTime (Get-Date).AddDays(-1) -EndTime (Get-Date) -WarningAction SilentlyContinue
$Output
}
