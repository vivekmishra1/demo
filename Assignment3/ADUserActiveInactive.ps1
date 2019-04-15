############################################################################## 
## List of Active/Inactive AD Users  
## Vivek Mishra

$out = Get-ADUser -Filter{name -like "*" } | Select-object Samaccountname,givenname,surname,enabled 
$out | Out-GridView
