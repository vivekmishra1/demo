############################################################################## 
## Azure VMs log 
## Vivek Mishra
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
