
param connection_name_ToTrustT0 string
// param storageConnectionToBlob string
// param connection_name_Untrusted string
// param storageConnectionToUntrusted string

// param principalID string
param tenantID string
param subscriptionId string 
param location string

param userAssignedIdentityPrincipalId string = ''
param displaynameToTrustT0 string

resource storageConnectionToTrustT0 'Microsoft.Web/connections@2016-06-01' = {
  name: connection_name_ToTrustT0
  location: location
  kind: 'V2'
  properties: {
    api: {
       id: '/subscriptions/${subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/azureblob'
      
    }
    parameterValueSet: {
      name: 'managedIdentityAuth'
      values: {}
    }
    displayName: displaynameToTrustT0  
  }
}
resource logicAppAccessPolicy 'Microsoft.Web/connections/accessPolicies@2016-06-01' = {
  name: '${connection_name_ToTrustT0}/uami-policy'
  properties: {
    principal: {
      type: 'ActiveDirectory'
      identity: {
      objectId: userAssignedIdentityPrincipalId
      tenantId: tenantID
      }
    }
  }
  dependsOn: [
    storageConnectionToTrustT0
  ]
}

output connectionRuntimeUrlazureblob string = storageConnectionToTrustT0.properties.connectionRuntimeUrl
