# This script will give System Information 
# Arunendra Chauhan

$hostSystem = Get-CimInstance CIM_ComputerSystem
$hostOS = Get-CimInstance CIM_OperatingSystem
$hostCPU = Get-CimInstance CIM_Processor
$hostHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"
Clear-Host

$Object = New-Object PSObject -Property @{
"System Name" = $hostSystem.Name 
"Domain Name" = $hostSystem.Domain
"Manufacturer" = $hostSystem.Manufacturer
"Model" = $hostSystem.Model
"RAM" = "{0:N2}" -f ($hostSystem.TotalPhysicalMemory/1GB) + "GB"
"CPU" = $hostCPU.Name
"HDD Capacity"  = "{0:N2}" -f ($hostHDD.Size/1GB) + "GB"
"HDD Space" = "{0:P2}" -f ($hostHDD.FreeSpace/$hostHDD.Size) + " Free (" + "{0:N2}" -f ($hostHDD.FreeSpace/1GB) + "GB)"
"No of Processors" = $hostCPU.NumberOfLogicalProcessors
"No of Cores" = $hostCPU.NumberOfCores
"Operating System" = $hostOS.caption + ", Service Pack: " + $hostOS.ServicePackMajorVersion
"OS Architecture" = $hostOS.OSArchitecture
"logged In User" = $hostSystem.UserName
"Last Reboot" = $hostOS.LastBootUpTime
} | Export-Csv C:\sysInfo.csv -NoTypeInformation -Encoding UTF8