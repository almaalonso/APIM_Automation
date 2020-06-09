
#Get Varables from configuration File
$configFile = $PSScriptRoot + '\configurationFile.json'
$variablesObj = Get-Content $configFile | ConvertFrom-Json

#Set Variables
$apimName = $variablesObj.createarmtemplate.apimName
$rgName = $variablesObj.createarmtemplate.rgName
$folderName = $variablesObj.folderName
$subId = $variablesObj.createarmtemplate.subId
$tenant = $variablesObj.createarmtemplate.tenant
$apiSuffix = $variablesObj.createarmtemplate.apiSuffix
$resource = $variablesObj.createarmtemplate.resource
$apiFilters = "path eq '"+ $apiSuffix +"'"
$filename = $PSScriptRoot +'\'+$folderName+'\' +$apimName +"_"+$apiSuffix+'.json'


#Get access_token from resource and set variable with JSON returned
$JSONAccessToken = az account get-access-token --resource $resource --subscription $subId

#Convert the JSON Objet to a Power Shell Object
$AccessToken = $JSONAccessToken | ConvertFrom-Json

#GET the ARM Template from Library API Management ARM Template Creator
Get-APIManagementTemplate -APIManagement $apimName -Token $AccessToken.accessToken -ResourceGroup $rgName -SubscriptionId $subId -TenantName $tenant -APIFilters $apiFilters -ExportPIManagementInstance $false | Out-File $filename





