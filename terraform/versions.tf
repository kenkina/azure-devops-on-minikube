terraform {
  required_version = "1.5.2"

  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.6.0"
    }
  }
}
