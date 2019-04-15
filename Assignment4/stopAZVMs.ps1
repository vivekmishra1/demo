############################################################################## 
## Stop Azure VM already running
## Vivek Mishra


$RG = 'myResourceGroup'
# Get VMs
$VMs = Get-AzVM -ResourceGroupName $RG

foreach($VM in $VMs) 
{
      ## Get VM running Status
      $VMInfo = Get-AzVM -ResourceGroupName $RG -Name $VM.Name -Status
      $VMStatus = $VMInfo.Statuses
      $VMRunningStatus = $VMStatus.DisplayStatus

      If($VMRunningStatus -eq "VM running"){
        Write-Output ("Azure VM " + $VM.Name + " is running. Let's stop it.") 
        ## Stop running VM
        $Stopvm = Stop-AzVM -Name $VM.Name -ResourceGroupName $RG -Force -ErrorAction Continue
        if (!$Stopvm.Status -eq "Succeeded") {
          # Unable to stop VM
          Write-Output (" Process to stop VM " + $VM.Name + " is failed")
        }
        else {
            Write-Output ("Azure VM " + $VM.Name + " has been stopped")
        }
      } ELSE {
            Write-Output ("Azure VM " + $VM.Name + " is not running")
            
      }
}
