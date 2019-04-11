## Insert key value pair to Az vault
## Arunendra Chauhan

$RG = 'keyVaultRG'
$Vaultname = 'myKeyVaultArun'
$j = @{

    psreventHubName = "timeseries-eh-psr"
    psrconsumerGrpName = "cntnr-2.0.0"
    psreventHubnamespace ="dataq-ts-eh-psr"
    psrSASName = "ListenPolicy"
    psrSASKey = ""

    storageAccountName = "dataqtssa"
    storageAccountKey = ""
    storageContainerName = "dataqjava"

    rawSamplesEventHubName = "timeseries-eh-rawsample"
    rawSamplesEventHubnamespace = "dataq-ts-eh-rawsamples"
    rawSamplesSASName = "SendPolicy"
    rawSamplesSASKey = ""
    
    psrStatusEventHubName = "timeseries-eh-psrstatus"
    psrStatusEventHubnamespace = "dataq-ts-eh-status"
    psrStatusSASName = "SendPolicy"
    psrStatusSASKey = ""
}

$j.Keys | ForEach-Object {
$key = '{0}' -f $_, $j[$_]
$value = '{1}' -f $_, $j[$_]
Write-Output $key   $value `n
$Secret = ConvertTo-SecureString $value -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $Vaultname -Name $key -SecretValue $Secret

} 

$j.Keys | ForEach-Object {
$key = '{0}' -f $_, $j[$_]
$value = '{1}' -f $_, $j[$_]
Write-Output $key 
(Get-AzureKeyVaultSecret -vaultName $Vaultname -name $key).SecretValueText 

} 
