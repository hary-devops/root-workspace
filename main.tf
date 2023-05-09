
module "static_web_distribution" {
  source                     = "./workspace/static-web-distribution"
  tfc_aws_audience           = var.tfc_aws_audience
  tfc_hostname               = var.tfc_hostname
  tfc_organization_name      = var.tfc_organization_name
  tfc_project_name           = var.tfc_project_name
  tfc_workspace_name         = var.tfc_workspace_name
  aws_region                 = var.aws_region
  aws_account_id             = var.aws_account_id
  slack_notification_webhook = var.slack_notification_webhook
}
