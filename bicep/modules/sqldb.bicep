param sqlServerName string
param sqlDatabaseName string
param location string
param administratorLogin string
@secure()
param administratorPassword string
param resourceTags object

resource sqlServer 'Microsoft.Sql/servers@2022-11-01-preview' = {
  name: sqlServerName
  location: location
  tags: resourceTags
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
  }
  dependsOn: []
}

resource servers_rideshare_server_name_databases_Rideshare_name 'Microsoft.Sql/servers/databases@2021-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  tags: resourceTags
  sku: {
    name: 'S0'
    tier: 'Standard'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 268435456000
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
  }
}

resource sqlAuditSettings 'Microsoft.Sql/servers/auditingSettings@2022-08-01-preview' = {
  name: 'default'
  parent: sqlServer
  properties: {
    isAzureMonitorTargetEnabled: true
    state: 'Enabled'
    retentionDays: 7
    auditActionsAndGroups: [
      'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
      'FAILED_DATABASE_AUTHENTICATION_GROUP'
      'BATCH_COMPLETED_GROUP'
    ]
  }
}
