## Terraform cloud 
terraform {
  cloud {
    organization = "harysetiawan23"
    workspaces {
      name = "workspace-creator"
    }
  }
}
