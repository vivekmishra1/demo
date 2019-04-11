## Set secret value to Azure key Vault
## Arunendra Chauhan

$RG = 'keyVaultRG'
$Vaultname = 'myKeyVaultArun'
$keyName = 'ExamplePassword'
$keyValue = 'Pa$$w0rd'

$kv = Get-AzureRmKeyVault -ResourceGroupName $RG -VaultName $Vaultname 
$secretvalue = ConvertTo-SecureString $keyValue -AsPlainText -Force 
Set-AzureKeyVaultSecret -VaultName $Vaultname -Name $keyName -SecretValue $secretvalue

(Get-AzureKeyVaultSecret -vaultName $Vaultname -name $keyName).SecretValueText