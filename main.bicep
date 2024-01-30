//can also be management group
targetScope = 'subscription'

param policyDefinitionName string = 'Allowed Locations' 
param resourceGroupToExempt string = 'rg-exempted'
param rgLocation string = deployment().location

var policyIds = loadJsonContent('./policies.json')

//create the resourcegroup
resource exemptedResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupToExempt
  location: rgLocation
}

//find a built-in policy definition at tenant level
resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2023-04-01' existing = {
  name: policyIds[policyDefinitionName]
  scope: tenant()
}

//create an assignment for the policy definition
//scope is subscription here
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
   name: 'policyAssignment'
   scope: subscription()
   properties: {
    displayName: 'My Assignment for locations'
    policyDefinitionId: policyDefinition.id
    parameters: {
      listOfAllowedLocations: {
        value: [
          'eastus'
          'eastus2'
          'westus'
        ]
      }
    }   
  }
}

//create a policy exception for a resource group
module exemptRg 'exemption-module.bicep' = {
  name: 'exemptRg'
  scope: resourceGroup(resourceGroupToExempt)
  params: {
    policyAssignmentId: policyAssignment.id
   
  }
}

