// This file is for doing static analysis and contains sensible defaults
// for the bicep analyser to minimise false-positives and provide the best results.

// This file is not intended to be used as a runtime configuration file.

targetScope = 'resourceGroup'

// Random, dummy data for static analysis
param sqlAdminLogin string = newGuid()
@secure()
param sqlAdminPassword string = newGuid()

module main 'main.bicep' = {
  name: 'main'
  params: {
    staticWebAppLocation: 'westus2'
    sqlAdminLogin: sqlAdminLogin
    sqlAdminPassword: sqlAdminPassword
  }
}
