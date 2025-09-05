using './main.bicep'

param location = 'germanywestcentral'
param nameObject = {
 client: 'pxs'
  workloadIdentifier: 'azure'
  environment: 'dev'
  region: 'gwc'
  purpose: 'pdt'
}


//Logic App 'pxs-azure-pdt-dev-gws-logicapps1"
param logicappdata = {
  purpose: 'pdt'
} 


//Trusted Storage Account 'pxsazuretrustdevgwcst1'
param storagesecuritydetailstrusted = {
  purpose: 'trust'
  publicNetworkAccess: 'Enabled' 
  allowBlobPublicAccess: false 
  sku: 'Standard_LRS'
  enableHierarchicalNamespace: false
  allowSharedKeyAccess: false 
  defaultToOAuthAuthentication: true 
}

//UnTrusted Storage Account 'pxsazureuntrustdevgwcst1'
param storagesecuritydetailsuntrusted = {
  purpose: 'untrust'
  publicNetworkAccess: 'Enabled' 
  allowBlobPublicAccess: false 
  //enablesftp: true 
  sku: 'Standard_LRS'
  enableHierarchicalNamespace: false
  allowSharedKeyAccess: false 
  defaultToOAuthAuthentication: true 
}
