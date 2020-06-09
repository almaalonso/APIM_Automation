
#Parameters
$kvSecretName = "blobstoragesecret"
$kvName = "kvblobstoragekey"
$bStorageSuffix = "Get New API/*"
$templateFileLocation = ".\Get New API\apim-np-integrations_newapi.json"
$paratemerFileLocation=".\Get New API\azureploy.parameters-p.json"


#Get Azure_Storage_Key from KeyVault
$keyvaultSecretObject = az keyvault secret show --name $kvSecretName --vault-nam $kvName
$keyVaultSecret = $keyvaultSecretObject | ConvertFrom-Json

#Download files from Blob Storage
az storage blob download-batch -d . -s $destinationContainer --pattern $bStorageSuffix --account-key $keyVaultSecret.value


#deploy the ARM template to the resource group set on the parameters file
az deployment group create --resource-group rg-p-integrations --template-file $templateFileLocation --parameters $paratemerFileLocation