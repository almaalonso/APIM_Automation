
#Set Variables
$apimName = 'apim-np-integrations'
$rgName = 'rg-np-integrations'
$folderName = 'New API'
$subId = '5de55397-c57a-4202-b7cb-16695807f288'
$tenant = 'e843640b-4a64-4021-ac40-987b9bd67ca0'
$apiSuffix = 'newapi'
$apiFilters = "path eq '"+ $apiSuffix +"'"
$filename = 'C:\Users\ALMAA\Documents\Biztalk\API Management\APIm Automation\' +$folderName+'\' +$apimName +"_"+$apiSuffix+'.json'
$resource = 'https://management.azure.com/'


#Get access_token from resource and set variable with JSON returned
$JSONAccessToken = az account get-access-token --resource $resource --subscription $subId

#Convert the JSON Objet to a Power Shell Object
$AccessToken = $JSONAccessToken | ConvertFrom-Json

#GET the ARM Template from Library API Management ARM Template Creator
Get-APIManagementTemplate -APIManagement $apimName -Token $AccessToken.accessToken -ResourceGroup $rgName -SubscriptionId $subId -TenantName $tenant -APIFilters $apiFilters -ExportPIManagementInstance $false | Out-File $filename





