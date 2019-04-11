#Using this script- Ping status for google will be stored in a csv
#Also it can be used for multiple hosts ping status

$Hosts = @("www.google.com")
$Hosts | ForEach-Object{
$pingstatus = ""
IF (Test-Connection -Count 1 -ComputerName $_ -Quiet) {
        $pingstatus = "Online"
} Else {
        $pingstatus = "Offline"
}

New-Object -TypeName PSObject -Property @{
      Host = $_
      Status = $pingstatus }
} | Export-Csv C:\pingStatus.csv -NoTypeInformation -Encoding UTF8