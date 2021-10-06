[CmdletBinding()]
param (
    [Parameter()][string]$VMNamePrefix = "VM",
    [Parameter()][ValidateSet('Win10',"Win2019Datacenter","Debian")][string]$Image = "Win10"
)

#VARIABLES
$SubscriptionID = "f40a70f2-06f5-4538-8c28-202faa6295f5"
$TenantID = "3ff61c02-8a76-4df3-8229-2b89d5a86816"
$ResourceGroupName = "EPSI"
$Location = "northeurope"
$VMName = $VMNamePrefix + ( Get-Random -Maximum 9999 )
$SubnetName = "EPSI_Subnet"
$VNETName = "EPSI_VNET"
$Username = "demouser"
$Password = "Password@123" | ConvertTo-SecureString -AsPlainText -Force
$Credentials = New-Object PSCredential($Username, $Password)
$VMSize = "Standard_A1_v2"


#Connect to subscription
$CurrentContext = Get-AzContext

if ( $CurrentContext )
{
    if ( $CurrentContext.Subscription.id -eq $SubscriptionID ) 
    {
        Write-Host "Connexion établie à la subcription $($CurrentContext.Subscription.Name)"
    }
    else 
    {
        $CurrentContext = Set-AzContext -Subscription $SubscriptionID -ErrorAction Stop
        Write-Host "Connexion établie à la subcription $($CurrentContext.Subscription.Name)"
    }
}
else
{
    Write-Host "Aucune authentification Azure en cours. Connexion ..." -ForegroundColor DarkYellow
    $CurrentContext = Connect-AzAccount -Tenant $TenantID -Subscription $SubscriptionID -ErrorAction Stop
    Write-Host "Connexion établie à la subcription $($CurrentContext.Subscription.Name)"
}

#Ressource Group
$ResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

if (-not ($ResourceGroup) )
{
    Write-Host "Resource Group $RessourceGroupName non trouvé. Création ..."
    $ResourceGroup = New-AzResourceGroup -Name $ResourceGroupName -Location $Location
}

#Subnet
Write-Host "Création du subnet: $SubnetName"
$SubnetConfig = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix 192.168.1.0/24 -WarningAction SilentlyContinue

#VNET
$VNET = Get-AzVirtualNetwork -Name $VNETName

if (-not ($VNET))
{
    Write-Host "Création du VNET: $VNETName"
    $VNET = New-AzVirtualNetwork -Name $VNETName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix 192.168.0.0/16 -Subnet $SubnetConfig   
}
else
{
    Write-Host "$VNETName déja présent"
}

#NIC
$NIC = New-AzNetworkInterface -Name "$VMName-NIC" -ResourceGroupName $ResourceGroupName -Location $Location -Subnet $VNET.Subnets[0]

#VM
try 
{
    Write-Host "Création de la VM: $VMName"

    $VM = New-AzVM -Name $VMName -ResourceGroupName $ResourceGroupName -Location $Location -Image $Image -VirtualNetworkName $VNETName -SubnetName $SubnetName -Credential $Credentials -Size $VMSize -PublicIpAddressName "$VMName-PIP" -OpenPorts 3389 -ErrorAction Stop  
}
catch 
{
    Write-Host "Erreur lors de la création de la VM: $($_.Exception.Message)"
}

[PSCustomObject]@{
    Name = $VMName
    IP   = (Get-AzPublicIpAddress -Name "$VMName-PIP").IpAddress
}

