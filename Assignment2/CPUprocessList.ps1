#Script to get top 10 CPU utilizing processes
$Server = "IN-IT0891"
Get-Process -ComputerName $Server | Sort -Descending -Property CPU |Select-Object -First 10 `
| Format-Table ProcessName, Id, SI, CPU



