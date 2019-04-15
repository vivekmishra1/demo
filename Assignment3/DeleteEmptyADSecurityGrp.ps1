############################################################################## 
## Deleting Empty Security Groups on Az -AD Server 
## Vivek Mishra

$deletedGrp = @()
$SecGroups = Get-ADGroup -SearchBase 'DC=globant, DC=com' -Filter {GroupCategory -eq "Security"} -Properties Members | ?{$_.Members.Count -eq 0} 
$SecGroups | ForEach-Object {
  try {
    Remove-ADGroup -Identity $_ -Confirm:$false
    $deletedGrp += "Security Group ($_) successfully deleted"
  } catch { $_.Exception.Response }
}
$deletedGrp  
