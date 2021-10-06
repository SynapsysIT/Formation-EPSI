# VARIABLES
#=================================================================
$VMName = "VM-" + (Get-Random -Maximum 9999)
$SubscriptionID = "f40a70f2-06f5-4538-8c28-202faa6295f5"
$TenantID = "3ff61c02-8a76-4df3-8229-2b89d5a86816"
$ResourceGroupName = "EPSI"
$Location = "northeurope"
$SubnetName = "VM_Subnet"
$VNET_Name = "EPSI_VNET"
$Image = "Win10"

#Credential
# Define a credential object to store the username and password for the VM
$UserName='demouser'
$Password='Password@123'| ConvertTo-SecureString -Force -AsPlainText
$Credential=New-Object PSCredential($UserName,$Password)

# EXECUTION
#=================================================================
#Connection

$CurrentAzContext = Get-AzContext
$CurrentAzContext.Subscription.Id

if ( $CurrentAzContext )
{
    if ($CurrentAzContext.Subscription.Id -eq $SubcriptionID)
    {
        Write-Host "Connexion Azure réutilisée" -ForegroundColor DarkYellow
    }
    else
    {
        $SelectedAZContext = Set-AzContext -Subscription "f40a70f2-06f5-4538-8c28-202faa6295f5"
        Write-Host "Connexion Azure établie. Sélection de la subscription: $($SelectedAZContext.Subscription.Name)" -ForegroundColor DarkYellow
    }
}
else
{
    $ConnectionInfo = Connect-AzAccount -SubscriptionId $SubscriptionID -TenantId $TenantID  -ErrorAction Stop

}

#Ressource Group
$RessourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -Location $Location -ErrorAction SilentlyContinue

if (-not ($RessourceGroup))
{
    $RessourceGroup =  New-AzResourceGroup -Name $ResourceGroupName -Location $Location
}


#Subnet / VNET
# Create a subnet configuration
$SubnetConfig = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix 192.168.1.0/24

# Create a virtual network
$VNETConfig = New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $location -Name MyVnet -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig

# Create a public IP address and specify a DNS name
$PrivateIP = New-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Location $location -AllocationMethod Static -Name "$($VMName)-PIP"

#NIC
$NIC = New-AzNetworkInterface -Name myNic -ResourceGroupName $ResourceGroupName -Location $location -SubnetId $VNETConfig.Subnets[0].Id -PublicIpAddressId $PrivateIP.Id 

New-AzVm -ResourceGroupName $RessourceGroupName -Name $VMName -Location $Location -Image $Image -VirtualNetworkName $VNET_Name -SubnetName $SubnetName -PublicIpAddressName $PrivateIP.Name -OpenPorts 3389 -Credential $Credential


#DELETE ALL
Remove-AzResourceGroup -Name $ResourceGroupName