############################################################################## 
## List of Active/Inactive AD Users  
## Arunendra Chauhan 

$out = Get-ADUser -Filter{name -like "*" } | Select-object Samaccountname,givenname,surname,enabled 
$out | Out-GridView