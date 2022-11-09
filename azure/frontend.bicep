////////////////////////////////////////////////////////////////////////////////
//
// Bicep Template for Azure Static Site
//
////////////////////////////////////////////////////////////////////////////////

// Parameters
// -----------------------------------------------------------------------------

@description('Name shared by function app resources.')
param appName string

@description('Suffix attached to all resource names.')
param appNameSuffix string = uniqueString(resourceGroup().id)

@description('GitHub repository ID: github.com/<repository>')
param repository string

@description('Branch to deploy from.')
param branch string = 'main'

@description('Location for all resources.')
param location string = resourceGroup().location


// Variables
// -----------------------------------------------------------------------------

var standardName = '${appName}-${appNameSuffix}'


// Resources
// -----------------------------------------------------------------------------

resource staticSite 'Microsoft.Web/staticSites@2022-03-01' = {
  name: standardName
  location: location
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    repositoryUrl: 'https://github.com/${repository}'
    branch: branch
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'GitHub'
    enterpriseGradeCdnStatus: 'Disabled'
    buildProperties: {
      skipGithubActionWorkflowGeneration: true
    }
  }
}

