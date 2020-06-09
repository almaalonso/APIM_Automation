
#Get Varables from configuration File
$configFile = $PSScriptRoot + '\configurationFile.json'
$variablesObj = Get-Content $configFile | ConvertFrom-Json

#Assign Variable from configuration File
$destinationContainer = $variablesObj.downuptemplate.containterurl
$kvSecretName = $variablesObj.downuptemplate.kvSecretName
$kvName = $variablesObj.downuptemplate.kvName
$bStorageSuffix = $variablesObj.deployarmtemplate.bStorageSuffix
$templateFileLocation = $variablesObj.deployarmtemplate.templateFileLocation
$paratemerFileLocation= $variablesObj.deployarmtemplate.paratemerFileLocation


#Get Azure_Storage_Key from KeyVault
$keyvaultSecretObject = az keyvault secret show --name $kvSecretName --vault-nam $kvName
$keyVaultSecret = $keyvaultSecretObject | ConvertFrom-Json

#Download files from Blob Storage
az storage blob download-batch -d . -s $destinationContainer --pattern $bStorageSuffix --account-key $keyVaultSecret.value


#deploy the ARM template to the resource group set on the parameters file
az deployment group create --resource-group $variablesJsonObject.deployarmtemplate.resourceGroup --template-file $templateFileLocation --parameters $paratemerFileLocation