
#$configurationFile: "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\extractSettings.json"
#principal ARM file: "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\Echo API\apim-np-integrations--echo-api-api.template.json"
#parameters file: "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\Echo API\apim-np-integrations-parameters.json"
#$destinationContainer = "https://apimautomation.blob.core.windows.net/apimautomationcontainer"
#$sourceFiles =  "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\New API"
#$destinationPath = "Get New API"

#extract the API definition template (ARM) according with settings in the configuration file
dotnet run extract --extractorConfig $configurationFile

#Get Azure_Storage_Key from KeyVault
$keyvaultSecretObject = az keyvault secret show --name blobstoragesecret --vault-nam kvblobstoragekey
$keyVaultSecret = $keyvaultSecretObject | ConvertFrom-Json

#save the files in a blob storage
az storage blob upload-batch -d $destinationContainer -s $sourceFiles --account-key $keyVaultSecret.value --destination-path $destinationPath

#Download Files from blob storage
az storage blob download-batch -d "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation" -s $destinationContainer --pattern "Get New API/*" --account-key $keyVaultSecret.value

#deploy the ARM template to the resource group set on the parameters file
az deployment group create --resource-group rg-p-integrations --template-file "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\New API\apim-np-integrations_newapi.json" --parameters "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\New API\azureploy.parameters-p.json"