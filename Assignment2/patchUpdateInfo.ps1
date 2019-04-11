Login-AzAccount

$VMs = Get-AzVM -ResourceGroupName myResourceGroup

$vmOutput = @()
$vmNames = @()
$VMs | ForEach-Object { 
  $tmpObj = New-Object -TypeName PSObject
  $tmpObj | Add-Member -MemberType Noteproperty -Name "VM Name" -Value $_.Name 
  $tmpObj | Add-Member -MemberType Noteproperty -Name "OS version" -Value $_.StorageProfile.OsDisk.OsType 
  $vmOutput += $tmpObj
  If ($tmpObj.'OS version' = "Windows") {
    $vmNames += $tmpObj.'VM Name'.ToString()
  }
}
#$vmOutput
Clear-Host
$vmNames
$vmNames | ForEach-Object {
    $VMprop = Get-AzVM -ResourceGroupName myResourceGroup 
    $VMprop | Get-HotFix -Description "Security*" -ComputerName $vmNames -Credential "$_\Admin123"
}


 

