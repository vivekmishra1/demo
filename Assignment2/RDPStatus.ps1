$RDPStatus = @()

FUNCTION RDPInfo {
if ((Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server').fDenyTSConnections -eq 1)

          { $RDPStatus = "RDP Connections not allowed"} 

elseif ((Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp').UserAuthentication -eq 1)
         { $RDPStatus = "Only Secure RDP Connections allowed"} 

else { $RDPStatus = "All Connections allowed"}
$RDPStatus
}  
RDPInfo
