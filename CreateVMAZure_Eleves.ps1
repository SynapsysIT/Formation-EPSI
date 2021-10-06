#VARIABLES
$SubscriptionID = "f40a70f2-06f5-4538-8c28-202faa6295f5"
$TenantID = "3ff61c02-8a76-4df3-8229-2b89d5a86816"


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
        
    }
}
else
{

}
#Ressource Group

#Subnet

#VNET

#NIC