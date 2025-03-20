Write-Host -NoNewLine "Getting shared Subscription...                   "
$SUBSCRIPTION="$(az account list --all --query "[?contains(name, 'IB-USA-CORPO-M-COMMONSERVICES')].id" -o tsv)"
Write-Host -ForegroundColor Green "[DONE]"
Write-Host -NoNewLine  "Getting utilities Resource Group....             "
$RESOURCE_GROUP="$(az group list --subscription=$SUBSCRIPTION --query "[?contains(name, 'rg-util-shared-001')].name" -o tsv)"
Write-Host -ForegroundColor Green "[DONE]"
Write-Host -NoNewLine "Getting tfstate Account Storage....              "
$ACCOUNT_NAME="$(az storage account list --subscription $SUBSCRIPTION -g $RESOURCE_GROUP --query "[[].name]" -o tsv)"
Write-Host -ForegroundColor Green "[DONE]"
Write-Host -NoNewLine "Getting tfstate Account Storage credentials....  "
$ACCOUNT_KEY=$(az storage account keys list --subscription $SUBSCRIPTION --resource-group $RESOURCE_GROUP --account-name $ACCOUNT_NAME --query '[0].value' -o tsv)
Write-Host -ForegroundColor Green "[DONE]"

$Env:ARM_ACCESS_KEY=$ACCOUNT_KEY

Write-Host "Environment has been set, Happy Terraforming!"
