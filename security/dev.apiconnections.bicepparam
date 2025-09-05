using './apiconnections.bicep'

param location = 'germanywestcentral'
param connection_name_ToTrustT0  = 'azureblob'
// param storageConnectionToBlob = 'azureblob' // Trusted Storage Account Incoming Container
// param connection_name_Untrusted = 'azureblob-2'
// param storageConnectionToUntrusted = 'azureblob-3' // UnTrusted Storage Account Outgoing Container

//param principalID = 'b8299ae5-c162-40db-b7c4-05f00421943a' // Managed Identity Object
param tenantID = '17b80ab3-78ea-40bf-bb47-869d4695895b' // Managed Identity Tenant

param displaynameToTrustT0 = 'azure blob'
// param displaynameUntrusted = 'Blob_Connect'

param subscriptionId = 'e0f7b10a-4a5c-4a5a-856b-0505f1a09fff'
