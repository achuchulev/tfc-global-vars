variable "tfe_token" {}

provider "tfe" {
  token = var.tfe_token # the token needs to have permissions to write variables to the workspaces
}

data "tfe_workspace_ids" "all" {
  names        = ["*"]
  organization = "atanasc-01" #"my-org-name"
}

# resource "null_resource" "MultiHelloWorld" {
#   triggers = {
#     uuid = uuid()
#   }
#   provisioner "local-exec" {
#     command = "echo ${data.tfe_workspace_ids.all.external_ids["aws-shared-credentials-file"]}"
#   }
# }

module "ws1" {
  source = "./the_variables"
  the_workspace_id = data.tfe_workspace_ids.all.external_ids["aws-shared-credentials-file"]
}

module "ws2" {
  source = "./the_variables"
  the_workspace_id = data.tfe_workspace_ids.all.external_ids["terraform-null-localexec"]
}
