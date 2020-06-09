
#Get Varables from configuration File
$PSScriptRoot = $PSScriptRoot + '\configurationFile.json'
$variablesJsonObject = Get-Content $PSScriptRoot | ConvertFrom-Json

#Assign Variable from configuration File
$kvSecretName = $variablesJsonObject.kvSecretName
$kvName = $variablesJsonObject.kvName
$bStorageSuffix = $variablesJsonObject.bStorageSuffix
$templateFileLocation = $variablesJsonObject.templateFileLocation
$paratemerFileLocation= $variablesJsonObject.paratemerFileLocation


#Get Azure_Storage_Key from KeyVault
$keyvaultSecretObject = az keyvault secret show --name $kvSecretName --vault-nam $kvName
$keyVaultSecret = $keyvaultSecretObject | ConvertFrom-Json

#Download files from Blob Storage
az storage blob download-batch -d . -s $destinationContainer --pattern $bStorageSuffix --account-key $keyVaultSecret.value


#deploy the ARM template to the resource group set on the parameters file
az deployment group create --resource-group $variablesJsonObject.resourceGroup --template-file $templateFileLocation --parameters $paratemerFileLocation