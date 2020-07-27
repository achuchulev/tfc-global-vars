variable "the_workspace_id" {}

resource "tfe_variable" "v1" {
  key          = "key_name"
  value        = "key_value"
  category     = "env"
  sensitive    = "true"
  workspace_id = var.the_workspace_id
}

resource "tfe_variable" "v2" {
  key          = "key_name"
  value        = "secret_key_value"
  category     = "env"
  sensitive    = "true"
  workspace_id = var.the_workspace_id
}
