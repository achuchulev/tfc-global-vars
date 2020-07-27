variable "tfe_token" {}

provider "tfe" {
  token = var.tfe_token # the token needs to have permissions to write variables to the workspaces
}

data "tfe_workspace_ids" "all" {
  names        = ["*"]
  organization = "my-org-name"
}

module "ws1" {
  source = "./the_variables"
  the_workspace_id = data.tfe_workspace_ids.all.external_ids["ws1"]
}

module "ws2" {
  source = "./the_variables"
  the_workspace_id = data.tfe_workspace_ids.all.external_ids["ws2"]
}
