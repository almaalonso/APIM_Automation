
#Get Varables from configuration File
$configFile = $PSScriptRoot + '\configurationFile.json'
$variablesObj = Get-Content $configFile | ConvertFrom-Json

$destinationContainer = $variablesObj.downuptemplate.containterurl
$folderName = $variablesObj.folderName
$kvSecretName = $variablesObj.downuptemplate.kvSecretName
$kvName =       $variablesObj.downuptemplate.kvName
$sourceFiles = $PSScriptRoot + '\' + $folderName

#Get Azure_Storage_Key from KeyVault
$keyvaultSecretObject = az keyvault secret show --name $kvSecretName --vault-nam $kvName
$keyVaultSecret = $keyvaultSecretObject | ConvertFrom-Json

az storage blob upload-batch -d $destinationContainer -s $sourceFiles --account-key $keyVaultSecret.value --destination-path $folderName