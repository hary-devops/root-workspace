# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "tfe" {
  hostname = var.tfc_hostname
}

# Runs in this workspace will be automatically authenticated
# to AWS with the permissions set in the AWS policy.
#
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace
resource "tfe_workspace" "static_web_distribution" {
  name              = var.tfc_workspace_name
  organization      = var.tfc_organization_name
  working_directory = "/environment/staging"
  project_id        = data.tfe_project.active.id
}


data "tfe_project" "active" {
  name         = var.tfc_project_name
  organization = var.tfc_organization_name
}
# The following variables must be set to allow runs
# to authenticate to AWS.
#
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable
resource "tfe_variable" "enable_aws_provider_auth" {
  workspace_id = tfe_workspace.static_web_distribution.id
  key          = "TFC_AWS_PROVIDER_AUTH"
  value        = "true"
  category     = "env"

  description = "Enable the Workload Identity integration for AWS."
}

resource "tfe_variable" "tfc_aws_role_arn" {
  workspace_id = tfe_workspace.static_web_distribution.id

  key      = "TFC_AWS_RUN_ROLE_ARN"
  value    = aws_iam_role.tfc_role.arn
  category = "env"

  description = "The AWS role arn runs will use to authenticate."
}

resource "tfe_variable" "tfc_aws_region" {
  workspace_id = tfe_workspace.static_web_distribution.id

  key      = "TF_VAR_aws_region"
  value    = var.aws_region
  category = "env"

  description = "The AWS Region."
}

resource "tfe_variable" "tfc_aws_account_id" {
  workspace_id = tfe_workspace.static_web_distribution.id

  key      = "TF_VAR_aws_account_id"
  value    = var.aws_account_id
  category = "env"

  description = "The AWS Region."
}

resource "tfe_notification_configuration" "slack_configuration" {
  destination_type = "slack"
  enabled          = true
  name             = "Webhook Service"
  url              = var.slack_notification_webhook
  workspace_id     = tfe_workspace.static_web_distribution.id
  triggers         = ["run:created", "run:planning", "run:needs_attention", "run:applying", "run:completed", "run:errored", "assessment:drifted", "assessment:failed"]
}



# The following variables are optional; uncomment the ones you need!

# resource "tfe_variable" "tfc_aws_audience" {
#   workspace_id = tfe_workspace.my_workspace.id

#   key      = "TFC_AWS_WORKLOAD_IDENTITY_AUDIENCE"
#   value    = var.tfc_aws_audience
#   category = "env"

#   description = "The value to use as the audience claim in run identity tokens"
# }
