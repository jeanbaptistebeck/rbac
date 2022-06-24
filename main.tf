resource "scalr_role" "planner" {
  name        = "Plan Creation"
  account_id  = local.account_id
  description = "Ability to create Terraform runs, but not approve"

  permissions = [
    "environments:read",
    "plans:read-json-output",
    "runs:cancel",
    "runs:create",
    "workspaces:read",
    "workspaces:set-schedule",
    "workspaces:update"
  ]
}

locals {
  account_id     = "acc-t477lugc9hh0rg0"
  environment_id = "env-u3ufnsatvldptg8"
}


resource "scalr_iam_team" "example" {
  name        = "myfirstscalrteam"
  description = "Scalr Example Team"
  account_id  = local.account_id
}

resource "scalr_access_policy" "team_min_access_to_acc_scope" {
  subject {
    type = "team"
    id   = scalr_iam_team.example.id
  }
  scope {
    type = "account"
    id   = local.account_id
  }
  ##This is a system role and the role ID will not change per account##
  role_ids = [
    "role-t58u316skvrgk2g"
  ]
}

##Link to an environment with role created earlier##
resource "scalr_access_policy" "team_access_to_env_scope" {
  subject {
    type = "team"
    id   = scalr_iam_team.example.id
  }
  scope {
    type = "environment"
    id   = local.environment_id
  }

  role_ids = [
    scalr_role.planner.id
  ]
}
