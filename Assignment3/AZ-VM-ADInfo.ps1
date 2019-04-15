############################################################################## 
## Info from Azure AD Servers   
## Vivek Mishra

Clear-Host
$Computers = Get-ADComputer -Filter * -Properties * | Select Name
$Output = @()
$Computers | ForEach-Object {
 $ADSvr = Get-ADComputer -Filter * -Properties * | `
 Select Name,OperatingSystemServicePack,OperatingSystemVersion,
 LastLogonDate,IPV4Address,CanonicalName,OperatingSystem,PasswordLastSet
 $Result = New-Object PSObject -Property @{
    'Server Name'           = $ADSvr.Name
    'Canonical Name'        = $ADSvr.CanonicalName
    'OS Name'               = $ADSvr.OperatingSystem
    'OS Version'            = $ADSvr.OperatingSystemVersion
    'OS Service Pack Version'  = $ADSvr.OperatingSystemServicePack
    'IPV4 Address'          = $ADSvr.IPV4Address
    'Last Logon Date'       = $ADSvr.LastLogonDate
    'Password Last Set'     = $ADSvr.PasswordLastSet
 }
 $Output +=  $Result
}
$Output | Out-GridView
