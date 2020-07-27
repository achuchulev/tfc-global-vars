variable "tfe_token" {}

provider "tfe" {
  token = var.tfe_token # the token needs to have permissions to write variables to the workspaces
}

data "tfe_workspace_ids" "ids" {
  names        = ["*"]
  organization = "atanasc-01" #"my-org-name"
}

module "ws1" {
  source = "./the_variables"
  #name = "aws-shared-credentials-file" #"ws1"
  the_workspace_id = data.tfe_workspace_ids.ids["aws-shared-credentials-file"]
}

module "ws2" {
  source = "./the_variables"
  #name = "terraform-null-localexec"
  the_workspace_id = data.tfe_workspace_ids.ids["terraform-null-localexec"] #["ws2"]
}
