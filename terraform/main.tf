# Make sure to set the following environment variables:
#  export AZDO_PERSONAL_ACCESS_TOKEN=xqwcus33u7fdl5lbqaykzlrwlcetovcnmlkcqsktdzvdnsu3snna
#  export AZDO_ORG_SERVICE_URL=https://dev.azure.com/dimp-org

resource "azuredevops_project" "project" {
  name        = "kovagger"
  description = "Managed by Terraform"
}

resource "azuredevops_git_repository" "kovagger_backend_java8_repository" {
  project_id = azuredevops_project.project.id
  name       = "kovagger_backend_java8"
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_build_folder" "kovagger_backend" {
  project_id  = azuredevops_project.project.id
  description = "Managed by Terraform"
  path        = "\\kovagger_backend"
}

resource "azuredevops_build_definition" "kovagger_backend_java8_build_definition" {
  project_id = azuredevops_project.project.id
  name       = "kovagger_backend_java8"
  path       = azuredevops_build_folder.kovagger_backend.path

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.kovagger_backend_java8_repository.id
    branch_name = azuredevops_git_repository.kovagger_backend_java8_repository.default_branch
    yml_path    = "azure-pipelines.yml"
  }
}

/*
# AZ ACR
resource "azuredevops_serviceendpoint_azurecr" "sc_azcr" {
  project_id                = azuredevops_project.project.id
  description               = "Managed by Terraform"
  service_endpoint_name     = "Example AzureCR"
  resource_group            = "example-rg"
  azurecr_spn_tenantid      = "00000000-0000-0000-0000-000000000000"
  azurecr_name              = "ExampleAcr"
  azurecr_subscription_id   = "00000000-0000-0000-0000-000000000000"
  azurecr_subscription_name = "subscription name"
}
*/

# Azure Resource Manager using service principal (manual)
# https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm

/*
# There is no OAuth
# https://discuss.hashicorp.com/t/creating-azure-devops-oauth-client-with-terraform-cloud-api/43301
resource "azuredevops_serviceendpoint_bitbucket" "sc_bitbucket" {
  project_id            = azuredevops_project.project.id
  username              = "username"
  password              = "password"
  service_endpoint_name = "Example Bitbucket"
  description           = "Managed by Terraform"
*/

/*
# Token?
# Error: Error creating service endpoint in Azure DevOps: Unable to find service connection type 'sonarcloud' using authentication scheme 'Token'.
resource "azuredevops_serviceendpoint_sonarcloud" "sc_sonarcloud" {
  project_id            = azuredevops_project.project.id
  description           = "Managed by Terraform"
  service_endpoint_name = "SCSonarCloudTrial"
  token                 = "0000000000000000000000000000000000000000"
}
*/

/*
Example with AZ Subs
resource "azuredevops_serviceendpoint_kubernetes" "example-azure" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "Example Kubernetes"
  apiserver_url         = "https://sample-kubernetes-cluster.hcp.westeurope.azmk8s.io"
  authorization_type    = "AzureSubscription"

  azure_subscription {
    subscription_id   = "00000000-0000-0000-0000-000000000000"
    subscription_name = "Example"
    tenant_id         = "00000000-0000-0000-0000-000000000000"
    resourcegroup_id  = "example-rg"
    namespace         = "default"
    cluster_name      = "example-aks"
  }
}
*/


resource "azuredevops_serviceendpoint_kubernetes" "sc_aks_shared_dev" {
  project_id            = azuredevops_project.project.id
  description           = "Managed by Terraform"
  service_endpoint_name = "sc_aks_shared_dev"
  apiserver_url         = "https://sample-kubernetes-cluster.hcp.westeurope.azmk8s.io"
  authorization_type    = "Kubeconfig"

  kubeconfig {
    kube_config            = <<EOT
                              apiVersion: v1
                              clusters:
                              - cluster:
                                  certificate-authority: fake-ca-file
                                  server: https://1.2.3.4
                                name: development
                              contexts:
                              - context:
                                  cluster: development
                                  namespace: frontend
                                  user: developer
                                name: dev-frontend
                              current-context: dev-frontend
                              kind: Config
                              preferences: {}
                              users:
                              - name: developer
                                user:
                                  client-certificate: fake-cert-file
                                  client-key: fake-key-file
                             EOT
    accept_untrusted_certs = true
  }
}

# Should use AZ Key Vault
resource "azuredevops_variable_group" "vg_ibkteam_devops_options_op" {
  project_id   = azuredevops_project.project.id
  name         = "ibkteam-devops-options-op"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "artifactoryXrayEnable"
    value = "false"
  }

  variable {
    name  = "fluidAttacksEnable"
    value = "false"
  }

  variable {
    name  = "sonarEnable"
    value = "false"
  }

  variable {
    name  = "sonarQualityGateEnable"
    value = "false"
  }
}

resource "azuredevops_variable_group" "vg_artifactory" {
  project_id   = azuredevops_project.project.id
  name         = "artifactory"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name         = "artifactory.token"
    secret_value = "aver"
    is_secret    = true
  }
}

resource "azuredevops_variable_group" "vg_sonarcloud" {
  project_id   = azuredevops_project.project.id
  name         = "sonarcloud"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name         = "sonarcloud.token"
    secret_value = "aver2"
    is_secret    = true
  }
}
