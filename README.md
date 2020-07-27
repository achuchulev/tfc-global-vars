## Using Terraform Enterprise (tfe) provider to setup Global (terraform|environment) variables for workspaces in Terraform Cloud(TFC)|Terraform Enterprise(TFE)

#### Probably the easiest option for now, that keeps variables management in a more systematic way than would be possible by creating them ad-hoc per-workspace, is to use the Terraform Enterprise (tfe) provider to automate setting variables across multiple (all) TFC(TFE) workspaces.

### Requirement

- Terraform >= 0.12

> Example:

#### One option to distribute variables and values in a managed way would be to create a workspace to manage the variable values.

- this configuration could be set up in a workspace in TFC. 
- when run, it would set the managed variables (v1 and v2) on the workspaces (ws1 and ws2). 
- when the values need to be changed or more variables or workspaces need to be added or removed, then the configuration can be updated and an apply would update all of the workspaces at once.

> Folder structure:

```
.
├── main.tf
└── global_variables
    └── variables.tf
```    

##### I. Adjust module `global_variables/variables.tf` to manage all of the Global variables needed:

```
variable "the_workspace_id" {}

resource "tfe_variable" "v1" {
  key          = "var1_name"
  value        = "var1_value"
  category     = "terraform"   # creates a terraform variable to the workspace
  sensitive    = "true"        # when omited defaults to "false"
  workspace_id = var.the_workspace_id
}

resource "tfe_variable" "v2" {
  key          = "var2_name"
  value        = "var2_value"
  category     = "env"       # creates an environment variable to the workspace
  sensitive    = "true"      # when omited defaults to "false"
  workspace_id = var.the_workspace_id
}
```

##### II. Adding a module per workspace in `./main.tf` will instantiate the module for each workspace to set those Global variables:

```
variable "tfe_token" {}

provider "tfe" {
  token = var.tfe_token    # the token needs to have permissions to write variables to the workspaces
}

data "tfe_workspace_ids" "ids" {
  names        = ["*"]
  organization = "my-org-name"
}

module "ws1" {
  source           = "./global_variables"
  the_workspace_id = data.tfe_workspace_ids.all.external_ids["ws1"]
}

module "ws2" {
  source           = "./global_variables"
  the_workspace_id = data.tfe_workspace_ids.all.external_ids["ws2"]
}
```

### How to use

- fork the repo
- adjust the __Global vars__ needed for the Organization within `global_variables/variables.tf`
- in `./main.tf` add a module for every workspace where the __Global vars__ are needed
- create a workspace in TFC/TFE that will namage the __Global vars__ and link it to the forked repo (make sure that `Include submodules on clone` is selected from the `Version Control` tab of workspace's settings)
- set a `tfe_token` for the `tfe` provider authentication as _terraform_ __sensitive__ variable (make sure that the token needs to have permissions to write variables to the workspaces)
- Run Plan/Apply
