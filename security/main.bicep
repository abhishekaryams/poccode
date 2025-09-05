// ---------------------- Parameters ----------------------
@description('Required. Name Object to create resource name')
param nameObject object
param location string
// ---------------------- Orchestration Bicep file ----------------------
targetScope = 'subscription'

@description('Optional. timestamp')
param timestamp string = utcNow()

@description('Required.Security details of the trusted storage account')
param storagesecuritydetailstrusted object

@description('Required.Security details of the untrusted storage account')
param storagesecuritydetailsuntrusted object

@description('Required.Details of the data logic app to be created')
param logicappdata object

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: '${nameObject.client}-${nameObject.workloadIdentifier}-${nameObject.purpose}-${nameObject.environment}-rg'
  location: location 

}

// module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
//   name: take('${timestamp}-userassigned-iac', 64)
//   scope: resourceGroup
//   params: {
//     name: '${nameObject.client}-${nameObject.workloadIdentifier}-${nameObject.purpose}-${nameObject.environment}-${nameObject.region}-id1'
//     location: location
//   }
// }
// output userAssignedIdentityPrincipalId string = userAssignedIdentity.outputs.principalId
// module userAssignedIdentity2 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
//   name: take('${timestamp}-userassigned2-iac', 64)
//   scope: resourceGroup
//   params: {
//     name: '${nameObject.client}-${nameObject.workloadIdentifier}-${nameObject.purpose}-${nameObject.environment}-${nameObject.region}-id2'
//     location: location
//   }
// }

// module serverfarm 'br/public:avm/res/web/serverfarm:0.5.0' = {
//   name: take('${timestamp}-asp-iac', 64)
//   scope: resourceGroup
//   params: {
//     name: '${nameObject.client}-${nameObject.workloadIdentifier}-${nameObject.purpose}-${nameObject.environment}-${nameObject.region}-asp1'
//     skuName: 'WS1'
//     skuCapacity: 1
//     maximumElasticWorkerCount: 1
//   }
// }


// module site 'br/public:avm/res/web/site:0.19.0' = {
//   name: take('${timestamp}-site-iac', 64)
//   scope: resourceGroup
//   params: {
//     kind: 'functionapp,workflowapp'
//     name: '${nameObject.client}-${nameObject.workloadIdentifier}-${logicappdata.purpose}-${nameObject.environment}-${nameObject.region}-logic1'
//     serverFarmResourceId: serverfarm.outputs.resourceId
//     basicPublishingCredentialsPolicies: [
//       {
//         allow: false
//         name: 'ftp'
//       }
//       {
//         allow: false
//         name: 'scm'
//       }
//     ]
//     location: resourceGroup.location
//     managedIdentities: {
//       userAssignedResourceIds: [
//         userAssignedIdentity.outputs.resourceId
//       ]
//     }
//     configs: [
//       {
//         name: 'appsettings'
//         properties: {
//           'AzureFile_storageAccountUri': 'https://${storagesecuritydetailstrustedblock.outputs.name}.file.core.windows.net/'
//           'AzureWebJobsStorage__blobServiceUri': 'https://${storagesecuritydetailstrustedblock.outputs.name}.blob.core.windows.net/'
//           'AzureWebJobsStorage__queueServiceUri': 'https://${storagesecuritydetailstrustedblock.outputs.name}.queue.core.windows.net/'
//           'AzureWebJobsStorage__tableServiceUri': 'https://${storagesecuritydetailstrustedblock.outputs.name}.table.core.windows.net/'
//           'AzureWebJobsStorage__managedIdentityResourceId': userAssignedIdentity.outputs.resourceId
//           'WEBSITE_NODE_DEFAULT_VERSION': '~18'
//           'FUNCTIONS_WORKER_RUNTIME': 'dotnet'
//           'FUNCTIONS_EXTENSION_VERSION': '~4'
//           'AzureFunctionsJobHost__extensionBundle__version': '[1.*, 2.0.0)'
//           'AzureFunctionsJobHost__extensionBundle__id': 'Microsoft.Azure.Functions.ExtensionBundle.Workflows'
//           'APP_KIND': 'workflowApp'
//           'AzureWebJobsStorage__credential': 'managedIdentity'
//         }
//       }
//     ]
//   }
// }


// Consumption Logic App is created using Powershell due to limitation in Bicep for passing complex objects to definitionParameters
// module consumptionlogicsite 'br/public:avm/res/logic/workflow:0.5.2' = {
//   name: take('${timestamp}-logic-iac', 64)
//   scope: resourceGroup
//   params: {
//     name: '${nameObject.client}-${nameObject.workloadIdentifier}-${consmptionlogicapp.purpose}-${nameObject.environment}-${nameObject.region}-logic1'
//     location: resourceGroup.location
//     //definitionParameters: workflowDefinition // Using Powershell to deploy the template
//     //integrationServiceEnvironmentId: logicappdata.integrationServiceEnvironmentId
//     managedIdentities: {
//       userAssignedResourceIds: [
//         userAssignedIdentity2.outputs.resourceId
//       ]
//     }
//     //parameters: logicappdata.parameters
//   }
// }

// -------------------- Automation Rule --------------------
// resource automation 'Microsoft.Security/automations@2023-12-01-preview' = {
//   name: 'Remove-Malware'
//   location: location
//   properties: {
//     description: 'Remove-Malware app'
//     isEnabled: true
//     scopes: [
//       {
//         description: 'scope for subscription ${subscription().subscriptionId}'
//         scopePath: '/subscriptions/${subscription().subscriptionId}'
//       }
//     ]
//     sources: [
//       {
//         eventSource: 'Alerts'
//         ruleSets: [
//           {
//             rules: [
//               {
//                 propertyJPath: 'Version'
//                 propertyType: 'String'
//                 expectedValue: '3.'
//                 operator: 'Contains'
//               }
//             ]
//           }
//         ]
//       }
//     ]
//     actions: [
//       {
//         actionType: 'LogicApp'
//         logicAppResourceId: '/subscriptions/688a85f1-e626-4601-b71d-d1b456fb6469/resourceGroups/rg-data-transfer-eastus-01/providers/Microsoft.Logic/workflows/Remove-MalwareBlob'
//         uri: 'https://prod-04.eastus2.logic.azure.com:443/workflows/a61063bd96414bfeb2336ab9ad51d19b'
//       }
//     ]
//   }
// }
 
// module storagesecuritydetailstrustedblock 'br/public:avm/res/storage/storage-account:0.26.0' = {
//   scope: resourceGroup
//   name: take('${timestamp}-trustedst-iac-1', 64)
//   params: {
//     name: '${nameObject.client}${nameObject.workloadIdentifier}${storagesecuritydetailstrusted.purpose}${nameObject.environment}${nameObject.region}st1'
//     publicNetworkAccess: storagesecuritydetailstrusted.publicNetworkAccess
//     allowBlobPublicAccess: storagesecuritydetailstrusted.allowBlobPublicAccess
//     allowSharedKeyAccess: storagesecuritydetailstrusted.allowSharedKeyAccess
//     skuName: storagesecuritydetailstrusted.sku
//     enableHierarchicalNamespace: storagesecuritydetailstrusted.enableHierarchicalNamespace
//     defaultToOAuthAuthentication: storagesecuritydetailstrusted.defaultToOAuthAuthentication
//     networkAcls: {
//       bypass: 'AzureServices'
//       defaultAction: 'Allow'
//     }
//     blobServices: {
//       containers: [
//        {
//           name: 'incoming'
//           publicAccess: 'None'
//           roleAssignments: [
//             {
//               principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Storage Blob Data Owner'           
//             }
//             {
//               principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Reader'              
//             }
// //             {
// //               principalId: 'b80e3558-1cf8-45ff-9b8f-3bcdfaf4cd4a' //PAW USERS
// //               principalType: 'Group'
// //               roleDefinitionIdOrName: 'Storage Blob Data Reader' 
// //               condition: '''
// // (
// //   (
// //     !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND !SubOperationMatches{'Blob.List'})
// //   )
// //   OR 
// //   (
// //     @Resource[Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags:Malware Scanning scan result<$key_case_sensitive$>] StringEqualsIgnoreCase 'No threats found'
// //   )
// // )
// // '''
// //               conditionVersion: '2.0'          
// //             }
// //             {
// //               principalId: 'b80e3558-1cf8-45ff-9b8f-3bcdfaf4cd4a' //PAW USERS
// //               principalType: 'Group'
// //               roleDefinitionIdOrName: 'Reader'              
// //             } //Commented out to avoid error on Middleware deployment
//           ]
//         }
//         {
//           name: 'outgoing'
//           publicAccess: 'None'
//           roleAssignments: [
//                      {
//               principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Storage Blob Data Owner'
//               condition: '''
// (
//   (
//     !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND !SubOperationMatches{'Blob.List'})
//   )
//   OR 
//   (
//     @Resource[Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags:Malware Scanning scan result<$key_case_sensitive$>] StringEqualsIgnoreCase 'No threats found'
//   )
// )
// '''
//               conditionVersion: '2.0'
//             }
//             {
//               principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Reader'             
//             }
//             // {
//             //   principalId: 'b80e3558-1cf8-45ff-9b8f-3bcdfaf4cd4a' //PAW USERS
//             //   principalType: 'Group'
//             //   roleDefinitionIdOrName: 'Reader'                       
//             // }
//             // {
//             //   principalId: 'b80e3558-1cf8-45ff-9b8f-3bcdfaf4cd4a' //PAW USERS
//             //   principalType: 'Group'
//             //   roleDefinitionIdOrName: 'Storage Blob Data Contributor'              
//             // }
//           ]
//         }
//         {
//           name: 'paw2paw'
//           publicAccess: 'None'
//           roleAssignments: [
//                      {
//               principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Storage Blob Data Owner'
//               condition: '''
// (
//   (
//     !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND !SubOperationMatches{'Blob.List'})
//   )
//   OR 
//   (
//     @Resource[Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags:Malware Scanning scan result<$key_case_sensitive$>] StringEqualsIgnoreCase 'No threats found'
//   )
// )
// '''
//               conditionVersion: '2.0'
//             }
//             {
//               principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Reader'             
//             }
//             // {
//             //   principalId: 'b80e3558-1cf8-45ff-9b8f-3bcdfaf4cd4a' //PAW USERS
//             //   principalType: 'Group'
//             //   roleDefinitionIdOrName: 'Reader'                       
//             // }
//             // {
//             //   principalId: 'b80e3558-1cf8-45ff-9b8f-3bcdfaf4cd4a' //PAW USERS
//             //   principalType: 'Group'
//             //   roleDefinitionIdOrName: 'Storage Blob Data Contributor'              
//             // }
//             ]
//     }
//   ]
// }
//     managedIdentities: {
//       userAssignedResourceIds: [
//        userAssignedIdentity.outputs.resourceId
//       ]
//     }
//     roleAssignments: [
//       {
//         principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Reader' 
//       }
//       {
//         principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Storage Account Contributor' 
//       }
//       {
//         principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Storage Blob Data Owner' 
//       }
//       {
//         principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Storage Queue Data Contributor' 
//       } 
//      {
//         principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Storage Table Data Contributor' 
//       }
//       // {
//       //   principalId: 'b80e3558-1cf8-45ff-9b8f-3bcdfaf4cd4a' //PAW USERS
//       //         principalType: 'Group'
//       //         roleDefinitionIdOrName: 'Reader' 
//       // } 
//        {
//               principalId: userAssignedIdentity2.outputs.principalId 
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Storage Blob Data Contributor'              
//             }
//     ]
//   }
// }


// module storagesecuritydetailsuntrustedblock 'br/public:avm/res/storage/storage-account:0.26.0' = {
//   scope: resourceGroup
//   name: take('${timestamp}-untrustedst-iac-1', 64)
//   params: {
//     name: '${nameObject.client}${nameObject.workloadIdentifier}${storagesecuritydetailsuntrusted.purpose}${nameObject.environment}${nameObject.region}st1'
//     publicNetworkAccess: storagesecuritydetailsuntrusted.publicNetworkAccess
//     allowBlobPublicAccess: storagesecuritydetailsuntrusted.allowBlobPublicAccess
//     allowSharedKeyAccess: storagesecuritydetailsuntrusted.allowSharedKeyAccess
//     skuName: storagesecuritydetailsuntrusted.sku
//     enableHierarchicalNamespace: storagesecuritydetailsuntrusted.enableHierarchicalNamespace
//     defaultToOAuthAuthentication: storagesecuritydetailsuntrusted.defaultToOAuthAuthentication
//     networkAcls: {
//       bypass: 'AzureServices'
//       defaultAction: 'Allow'
//     }
//     blobServices: {
//       containers: [
//         {
//           name: 'incoming'
//           publicAccess: 'None'
//  roleAssignments: [
//             {
//               principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Storage Blob Data Owner'           
//             }
//             {
//               principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Reader'              
//             }
// //             {
// //               principalId: 'c710cb90-a0a4-47a2-beb5-23fe2edf9fc0' // UNTRUSTED USERS
// //               principalType: 'Group'
// //               roleDefinitionIdOrName: 'Storage Blob Data Reader' 
// //               condition: '''
// // (
// //   (
// //     !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND !SubOperationMatches{'Blob.List'})
// //   )
// //   OR 
// //   (
// //     @Resource[Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags:Malware Scanning scan result<$key_case_sensitive$>] StringEqualsIgnoreCase 'No threats found'
// //   )
// // )
// // '''
// //               conditionVersion: '2.0'          
// //             }
// //             {
// //               principalId: 'c710cb90-a0a4-47a2-beb5-23fe2edf9fc0' // UNTRUSTED USERS
// //               principalType: 'Group'
// //               roleDefinitionIdOrName: 'Reader'              
// //             } //Commented out to avoid error on Middleware deployment
//           ]
//         }
//         {
//           name: 'outgoing'
//           publicAccess: 'None'
//  roleAssignments: [
//                      {
//               principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Storage Blob Data Owner'
//               condition: '''
// (
//   (
//     !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND !SubOperationMatches{'Blob.List'})
//   )
//   OR 
//   (
//     @Resource[Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags:Malware Scanning scan result<$key_case_sensitive$>] StringEqualsIgnoreCase 'No threats found'
//   )
// )
// '''
//               conditionVersion: '2.0'
//             }
//             {
//               principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Reader'             
//             }
//             // {
//             //   principalId: 'c710cb90-a0a4-47a2-beb5-23fe2edf9fc0' // UNTRUSTED USERS
//             //   principalType: 'Group'
//             //   roleDefinitionIdOrName: 'Reader'                       
//             // }
//             // {
//             //   principalId: 'c710cb90-a0a4-47a2-beb5-23fe2edf9fc0' // UNTRUSTED USERS
//             //   principalType: 'Group'
//             //   roleDefinitionIdOrName: 'Storage Blob Data Contributor'              
//             // }
//           ]
//         }
//       ]
//     }
//     managedIdentities: {
//       userAssignedResourceIds: [
//         userAssignedIdentity.outputs.resourceId
//       ]
//     }
//     roleAssignments: [
//     {
//         principalId: userAssignedIdentity.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Reader' 
//       }
//       {
//         principalId: userAssignedIdentity2.outputs.principalId
//               principalType: 'ServicePrincipal'
//               roleDefinitionIdOrName: 'Storage Blob Data Contributor'
//       }
//         // {
//         //       principalId: 'c710cb90-a0a4-47a2-beb5-23fe2edf9fc0' // UNTRUSTED USERS
//         //       principalType: 'Group'
//         //       roleDefinitionIdOrName: 'Reader'              
//         //     }

//     ]

//   }
// }



