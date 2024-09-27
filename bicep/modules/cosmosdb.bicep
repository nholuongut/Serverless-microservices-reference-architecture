  
@description('Cosmos DB account name')
param accountName string

@description('Location for the Cosmos DB account.')
param location string = resourceGroup().location

@description('The name for the Core (SQL) database')
param databaseName string
param resourceTags object

param throughput int = 400

var containerNames = [
  'main'
  'archiver'
]

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' = {
  name: toLower(accountName)
  kind: 'GlobalDocumentDB'
  location: location
  tags: resourceTags
  properties: {
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    enableFreeTier: false
    locations: [
      {
        locationName: location
      }
    ]
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
          backupIntervalInMinutes: 240
          backupRetentionIntervalInHours: 8
      }
    }
    minimalTlsVersion: 'Tls12'
  }
}

resource cosmosDB 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-06-15' = {
  name: '${toLower(databaseName)}'
  parent: cosmosAccount
  tags: resourceTags
  properties: {
    resource: {
      id: '${toLower(databaseName)}'
    }
    options: {
      throughput: throughput
    }
  }
}

resource containers 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-06-15' = [for cotainerName in containerNames :{
  name: cotainerName
  parent: cosmosDB
  tags: resourceTags
  properties: {
    resource: {
      id: cotainerName
      partitionKey: {
        paths: [
          '/code'
        ]
      }
    }
  }
}]

output cosmosDBAccountName string = cosmosAccount.name
