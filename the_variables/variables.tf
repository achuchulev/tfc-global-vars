variable "the_workspace_id" {}

resource "tfe_variable" "v1" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = "access_key_value"
  category     = "env"
  sensitive    = "true"
  workspace_id = var.the_workspace_id
}

resource "tfe_variable" "v2" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "secret_key_value"
  category     = "env"
  sensitive    = "true"
  workspace_id = var.the_workspace_id
}
