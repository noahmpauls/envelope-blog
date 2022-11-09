////////////////////////////////////////////////////////////////////////////////
//
// Bicep Template for Netlify CMS Backend Function App
//
////////////////////////////////////////////////////////////////////////////////

// Parameters
// -----------------------------------------------------------------------------

@description('Name shared by function app resources.')
param appName string

@description('Suffix attached to all resource names.')
param appNameSuffix string = uniqueString(resourceGroup().id)

@description('Storage account type.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param storageAccountType string = 'Standard_LRS'

@description('Location for all resources.')
param location string = resourceGroup().location

param oauthClientId string

@secure()
param oauthClientSecret string

param redirectUrl string

param origin string


// Variables
// -----------------------------------------------------------------------------

var standardName = '${appName}-${appNameSuffix}'
var functionAppName = standardName
var hostingPlanName = standardName
var appInsightsName = standardName
var storageAccountName = '${appName}${appNameSuffix}'


// Resources
// -----------------------------------------------------------------------------

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku:{
    name: storageAccountType
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: { }
}

resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: hostingPlan.id
    clientAffinityEnabled: false
    httpsOnly: true
    siteConfig: {
      alwaysOn: false
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~14'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'OAUTH_CLIENT_ID'
          value: oauthClientId
        }
        {
          name: 'OAUTH_CLIENT_SECRET'
          value: oauthClientSecret
        }
        {
          name: 'ORIGIN'
          value: origin
        }
        {
          name: 'REDIRECT_URL'
          value: redirectUrl
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
  }
}
