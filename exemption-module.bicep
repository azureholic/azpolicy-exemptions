param policyAssignmentId string

resource policyExemption 'Microsoft.Authorization/policyExemptions@2022-07-01-preview' = {
  name: 'policyExemption'
  properties: {
    displayName: 'My Exemption for locations'
    policyAssignmentId: policyAssignmentId
    exemptionCategory: 'Waiver'
    expiresOn: '2025-12-31'
    metadata: {
      myKey: 'some value'

    }
  }
}

