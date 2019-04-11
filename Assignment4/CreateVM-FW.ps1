## Script to stop firewall for all VMs 
## In this script first a VM will get created with firewall enabled
# Later FW disabled and Again enabled
## Arunendra Chauhan

#Login-AzAccount
#ResourceGroup name and location
$RG="myResourceGroupfw"
$Location="East US"
$StorageName = "stgfwarun"
$VMName = "myFWVM"

Function CreateVMFW {
#Create new RG
New-AzureRMResourceGroup -Name $RG -Location $Location

#Create new Storage
New-AzureRMStorageAccount -ResourceGroupName $RG -Name $StorageName -Location $Location -SkuName Standard_LRS 

#User credentials for Server VMs
$securePassword = ConvertTo-SecureString 'P@$$W0rd010203' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("AzfwUser", $securePassword)

#Create Vnet
$VnetName=$RG+"Vnet"
New-AzureRMVirtualNetwork -ResourceGroupName $RG -Name $VnetName -AddressPrefix 192.168.0.0/16 -Location $Location

#Configure subnets
$vnet = Get-AzureRMVirtualNetwork -ResourceGroupName $RG -Name $VnetName
Add-AzureRMVirtualNetworkSubnetConfig -Name AzureFirewallSubnet -VirtualNetwork $vnet -AddressPrefix 192.168.1.0/24
Add-AzureRMVirtualNetworkSubnetConfig -Name ServersSubnet -VirtualNetwork $vnet -AddressPrefix 192.168.2.0/24
Set-AzureRMVirtualNetwork -VirtualNetwork $vnet

#create Public IP for jumpbox and LB
$PipName = $RG + "PublicIP"
$Pip = New-AzureRMPublicIpAddress -Name $PipName  -ResourceGroupName $RG -Location $Location -AllocationMethod Static -Sku Standard


# Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzureRMNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleSSH  -Protocol Tcp `
 -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow

# Create a network security group
$NsgName = $RG+"NSG"
$nsg = New-AzureRMNetworkSecurityGroup -ResourceGroupName $RG -Location $Location -Name $NsgName -SecurityRules $nsgRuleRDP

#Create Server VM
$ServersSubnetId = $vnet.Subnets[1].Id
$ServerVmNic = New-AzureRMNetworkInterface -Name ServerVmNic -ResourceGroupName $RG -Location $Location -SubnetId $ServersSubnetId
$ServerVmConfig = New-AzureRMVMConfig -VMName $VMName -VMSize Standard_DS1_v2 | Set-AzureRMVMOperatingSystem -Windows -ComputerName $VMName -Credential $cred | Set-AzureRMVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version latest | Add-AzureRMVMNetworkInterface -Id $ServerVmNic.Id
New-AzureRMVM -ResourceGroupName $RG -Location $Location -VM $ServerVmConfig

#Create AzureRMFW
$GatewayName = $RG + "Azfw"
$Azfw = New-AzureRMFirewall -Name $GatewayName -ResourceGroupName $RG -Location $Location -VirtualNetworkName $vnet.Name -PublicIpName $Pip.Name

#Add a rule to allow *microsoft.com
$Azfw = Get-AzureRMFirewall -ResourceGroupName $RG
$Rule = New-AzureRMFirewallApplicationRule -Name R1 -Protocol "http:80","https:443" -TargetFqdn "*microsoft.com"
$RuleCollection = New-AzureRMFirewallApplicationRuleCollection -Name RC1 -Priority 100 -Rule $Rule -ActionType "Allow"
$Azfw.ApplicationRuleCollections = $RuleCollection
Set-AzureRMFirewall -AzureFirewall $Azfw

#associate to Servers Subnet
Set-AzureRMVirtualNetwork -VirtualNetwork $vnet
}

Function StopFirewall {

$azfw = Get-AzureRMFirewall -Name $GatewayName -ResourceGroupName $RG
$azfw.Deallocate()
Set-AzureRMFirewall -AzureFirewall $azfw

}

Function StartFirewall {
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $RG -Name $VNetName
$publicip = Get-AzureRmPublicIpAddress -Name $PipName -ResourceGroupName $RG
$azfw.Allocate($vnet,$publicip)
Set-AzureRmFirewall -AzureFirewall $azfw

}

CreateVMFW
StopFirewall
StartFirewall

