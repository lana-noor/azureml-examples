targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param pythonAndPipExists bool
@secure()
param pythonAndPipDefinition object
param mlflowModelExists bool
@secure()
param mlflowModelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param basicChatExists bool
@secure()
param basicChatDefinition object
param imageBuildWithReqirementsExists bool
@secure()
param imageBuildWithReqirementsDefinition object
param modelExists bool
@secure()
param modelDefinition object
param basicExists bool
@secure()
param basicDefinition object
param irisExists bool
@secure()
param irisDefinition object
param srcExists bool
@secure()
param srcDefinition object
param dockerContextExists bool
@secure()
param dockerContextDefinition object
param dockerContextExists bool
@secure()
param dockerContextDefinition object
param azureMLSamplesCSharpExists bool
@secure()
param azureMLSamplesCSharpDefinition object
param batchExists bool
@secure()
param batchDefinition object
param modelExists bool
@secure()
param modelDefinition object
param pythonAndPipExists bool
@secure()
param pythonAndPipDefinition object
param mlflowModelExists bool
@secure()
param mlflowModelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param modelExists bool
@secure()
param modelDefinition object
param langchainExists bool
@secure()
param langchainDefinition object
param skExists bool
@secure()
param skDefinition object
param modelExists bool
@secure()
param modelDefinition object
param importExists bool
@secure()
param importDefinition object
param bringYourOwnDataChatQnaExists bool
@secure()
param bringYourOwnDataChatQnaDefinition object
param chatWithIndexExists bool
@secure()
param chatWithIndexDefinition object
param imagecnnTrainExists bool
@secure()
param imagecnnTrainDefinition object
param yolov5Exists bool
@secure()
param yolov5Definition object
param srcExists bool
@secure()
param srcDefinition object
param srcExists bool
@secure()
param srcDefinition object
param mlflowDeploymentWithExplanationsExists bool
@secure()
param mlflowDeploymentWithExplanationsDefinition object
param modelExists bool
@secure()
param modelDefinition object
param typescriptExists bool
@secure()
param typescriptDefinition object
param e2eDistributedPytorchImageExists bool
@secure()
param e2eDistributedPytorchImageDefinition object
param creditDefaultsModelExists bool
@secure()
param creditDefaultsModelDefinition object

@description('Id of the user or app to assign application roles')
param principalId string

// Tags that should be applied to all resources.
// 
// Note that 'azd-service-name' tags should be applied separately to service host resources.
// Example usage:
//   tags: union(tags, { 'azd-service-name': <service name in azure.yaml> })
var tags = {
  'azd-env-name': environmentName
}

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module monitoring './shared/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
    tags: tags
    logAnalyticsName: '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
    applicationInsightsName: '${abbrs.insightsComponents}${resourceToken}'
  }
  scope: rg
}

module dashboard './shared/dashboard-web.bicep' = {
  name: 'dashboard'
  params: {
    name: '${abbrs.portalDashboards}${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    location: location
    tags: tags
  }
  scope: rg
}

module registry './shared/registry.bicep' = {
  name: 'registry'
  params: {
    location: location
    tags: tags
    name: '${abbrs.containerRegistryRegistries}${resourceToken}'
  }
  scope: rg
}

module keyVault './shared/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    tags: tags
    name: '${abbrs.keyVaultVaults}${resourceToken}'
    principalId: principalId
  }
  scope: rg
}

module appsEnv './shared/apps-env.bicep' = {
  name: 'apps-env'
  params: {
    name: '${abbrs.appManagedEnvironments}${resourceToken}'
    location: location
    tags: tags
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    logAnalyticsWorkspaceName: monitoring.outputs.logAnalyticsWorkspaceName
  }
  scope: rg
}

module pythonAndPip './app/python-and-pip.bicep' = {
  name: 'python-and-pip'
  params: {
    name: '${abbrs.appContainerApps}python-and-p-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}python-and-p-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: pythonAndPipExists
    appDefinition: pythonAndPipDefinition
  }
  scope: rg
}

module mlflowModel './app/mlflow-model.bicep' = {
  name: 'mlflow-model'
  params: {
    name: '${abbrs.appContainerApps}mlflow-model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}mlflow-model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: mlflowModelExists
    appDefinition: mlflowModelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module basicChat './app/basic-chat.bicep' = {
  name: 'basic-chat'
  params: {
    name: '${abbrs.appContainerApps}basic-chat-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}basic-chat-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: basicChatExists
    appDefinition: basicChatDefinition
  }
  scope: rg
}

module imageBuildWithReqirements './app/image_build_with_reqirements.bicep' = {
  name: 'image_build_with_reqirements'
  params: {
    name: '${abbrs.appContainerApps}image-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}image-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: imageBuildWithReqirementsExists
    appDefinition: imageBuildWithReqirementsDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module basic './app/basic.bicep' = {
  name: 'basic'
  params: {
    name: '${abbrs.appContainerApps}basic-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}basic-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: basicExists
    appDefinition: basicDefinition
  }
  scope: rg
}

module iris './app/iris.bicep' = {
  name: 'iris'
  params: {
    name: '${abbrs.appContainerApps}iris-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}iris-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: irisExists
    appDefinition: irisDefinition
  }
  scope: rg
}

module src './app/src.bicep' = {
  name: 'src'
  params: {
    name: '${abbrs.appContainerApps}src-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}src-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: srcExists
    appDefinition: srcDefinition
  }
  scope: rg
}

module dockerContext './app/docker-context.bicep' = {
  name: 'docker-context'
  params: {
    name: '${abbrs.appContainerApps}docker-conte-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}docker-conte-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: dockerContextExists
    appDefinition: dockerContextDefinition
  }
  scope: rg
}

module dockerContext './app/docker-context.bicep' = {
  name: 'docker-context'
  params: {
    name: '${abbrs.appContainerApps}docker-conte-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}docker-conte-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: dockerContextExists
    appDefinition: dockerContextDefinition
  }
  scope: rg
}

module azureMLSamplesCSharp './app/AzureML-Samples-CSharp.bicep' = {
  name: 'AzureML-Samples-CSharp'
  params: {
    name: '${abbrs.appContainerApps}azureml-samp-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}azureml-samp-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: azureMLSamplesCSharpExists
    appDefinition: azureMLSamplesCSharpDefinition
  }
  scope: rg
}

module batch './app/batch.bicep' = {
  name: 'batch'
  params: {
    name: '${abbrs.appContainerApps}batch-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}batch-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: batchExists
    appDefinition: batchDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module pythonAndPip './app/python-and-pip.bicep' = {
  name: 'python-and-pip'
  params: {
    name: '${abbrs.appContainerApps}python-and-p-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}python-and-p-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: pythonAndPipExists
    appDefinition: pythonAndPipDefinition
  }
  scope: rg
}

module mlflowModel './app/mlflow-model.bicep' = {
  name: 'mlflow-model'
  params: {
    name: '${abbrs.appContainerApps}mlflow-model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}mlflow-model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: mlflowModelExists
    appDefinition: mlflowModelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module langchain './app/langchain.bicep' = {
  name: 'langchain'
  params: {
    name: '${abbrs.appContainerApps}langchain-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}langchain-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: langchainExists
    appDefinition: langchainDefinition
  }
  scope: rg
}

module sk './app/sk.bicep' = {
  name: 'sk'
  params: {
    name: '${abbrs.appContainerApps}sk-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}sk-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: skExists
    appDefinition: skDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module import './app/import.bicep' = {
  name: 'import'
  params: {
    name: '${abbrs.appContainerApps}import-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}import-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: importExists
    appDefinition: importDefinition
  }
  scope: rg
}

module bringYourOwnDataChatQna './app/bring_your_own_data_chat_qna.bicep' = {
  name: 'bring_your_own_data_chat_qna'
  params: {
    name: '${abbrs.appContainerApps}bring-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}bring-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: bringYourOwnDataChatQnaExists
    appDefinition: bringYourOwnDataChatQnaDefinition
  }
  scope: rg
}

module chatWithIndex './app/chat-with-index.bicep' = {
  name: 'chat-with-index'
  params: {
    name: '${abbrs.appContainerApps}chat-with-in-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}chat-with-in-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: chatWithIndexExists
    appDefinition: chatWithIndexDefinition
  }
  scope: rg
}

module imagecnnTrain './app/imagecnn_train.bicep' = {
  name: 'imagecnn_train'
  params: {
    name: '${abbrs.appContainerApps}imagecnn-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}imagecnn-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: imagecnnTrainExists
    appDefinition: imagecnnTrainDefinition
  }
  scope: rg
}

module yolov5 './app/yolov5.bicep' = {
  name: 'yolov5'
  params: {
    name: '${abbrs.appContainerApps}yolov5-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}yolov5-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: yolov5Exists
    appDefinition: yolov5Definition
  }
  scope: rg
}

module src './app/src.bicep' = {
  name: 'src'
  params: {
    name: '${abbrs.appContainerApps}src-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}src-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: srcExists
    appDefinition: srcDefinition
  }
  scope: rg
}

module src './app/src.bicep' = {
  name: 'src'
  params: {
    name: '${abbrs.appContainerApps}src-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}src-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: srcExists
    appDefinition: srcDefinition
  }
  scope: rg
}

module mlflowDeploymentWithExplanations './app/mlflow-deployment-with-explanations.bicep' = {
  name: 'mlflow-deployment-with-explanations'
  params: {
    name: '${abbrs.appContainerApps}mlflow-deplo-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}mlflow-deplo-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: mlflowDeploymentWithExplanationsExists
    appDefinition: mlflowDeploymentWithExplanationsDefinition
  }
  scope: rg
}

module model './app/model.bicep' = {
  name: 'model'
  params: {
    name: '${abbrs.appContainerApps}model-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}model-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: modelExists
    appDefinition: modelDefinition
  }
  scope: rg
}

module typescript './app/typescript.bicep' = {
  name: 'typescript'
  params: {
    name: '${abbrs.appContainerApps}typescript-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}typescript-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: typescriptExists
    appDefinition: typescriptDefinition
  }
  scope: rg
}

module e2eDistributedPytorchImage './app/e2e-distributed-pytorch-image.bicep' = {
  name: 'e2e-distributed-pytorch-image'
  params: {
    name: '${abbrs.appContainerApps}e2e-distribu-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}e2e-distribu-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: e2eDistributedPytorchImageExists
    appDefinition: e2eDistributedPytorchImageDefinition
  }
  scope: rg
}

module creditDefaultsModel './app/credit_defaults_model.bicep' = {
  name: 'credit_defaults_model'
  params: {
    name: '${abbrs.appContainerApps}credit-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}credit-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: creditDefaultsModelExists
    appDefinition: creditDefaultsModelDefinition
  }
  scope: rg
}

output AZURE_CONTAINER_REGISTRY_ENDPOINT string = registry.outputs.loginServer
output AZURE_KEY_VAULT_NAME string = keyVault.outputs.name
output AZURE_KEY_VAULT_ENDPOINT string = keyVault.outputs.endpoint
