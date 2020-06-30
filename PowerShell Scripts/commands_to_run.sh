
$configurationFile = "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\extractSettings_new.json"
principal ARM file: "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\Echo API\apim-np-integrations--echo-api-api.template.json"
parameters file: "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\Echo API\apim-np-integrations-parameters.json"
$destinationContainer = "https://sanpapim.blob.core.windows.net/containerapim"
$sourceFiles =  "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\Pet Store API"
$destinationPath = "Pet Store API"
$yamlFilePath = 'C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\azure-api-management-devops-resource-kit\src\APIM_ARMTemplate\apimtemplate\Creator\ExampleFiles\YAMLConfigs\valid2.yml'

#extract the API definition template (ARM) according with settings in the configuration file
dotnet run extract --extractorConfig $configurationFile

#Create an ARM template from YAML File
dotnet run create --configFile $yamlFilePath

#Get Azure_Storage_Key from KeyVault
$keyvaultSecretObject = az keyvault secret show --name secretcontainer --vault-nam kvnpapim
$keyVaultSecret = $keyvaultSecretObject | ConvertFrom-Json

#save the files in a blob storage
az storage blob upload-batch -d $destinationContainer -s $sourceFiles --account-key $keyVaultSecret.value --destination-path $destinationPath

#Download Files from blob storage
az storage blob download-batch -d "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation" -s $destinationContainer --pattern "Get New API/*" --account-key $keyVaultSecret.value

#deploy the ARM template to the resource group set on the parameters fileC:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\Creator API\myAPI-initial.api.template.json
az deployment group create --resource-group rg-np-integrations --template-file "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\Pet Store API\apim-np-integration-master.template.json" --parameters "C:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\Pet Store API\apim-np-integration-parameters.json"



#deploy the ARM template to the resource group set on the parameters fileC:\Users\ALMAA\Documents\Biztalk\API Management\Apim Automation\Creator API\myAPI-initial.api.template.json
az deployment group create --resource-group rg-np-integrations --template-file $masterSourceFile --parameters $parametersSourceFile