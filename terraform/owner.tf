resource "aws_identitystore_user" "owner" {
  identity_store_id = local.identity_store_id

  display_name = "AWS Control Tower Admin"
  user_name    = "murray_tait@hotmail.com"

  name {
    given_name  = "AWS Control Tower"
    family_name = "Admin"
  }

  emails {
    value   = "murray_tait@hotmail.com"
    type    = "work"
    primary = true
  }
}

resource "aws_identitystore_group_membership" "owner_terraform_access" {
  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.terraform_state_access.group_id
  member_id         = aws_identitystore_user.owner.user_id
}

data "aws_identitystore_group_memberships" "terraform_state_access" {
  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.terraform_state_access.group_id
}

resource "aws_ssoadmin_account_assignment" "terraform_state_access_owner" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_state_access.arn

  principal_id   = aws_identitystore_user.owner.user_id
  principal_type = "USER"

  target_id   = aws_organizations_account.build.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "build_admin_access_owner" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn

  principal_id   = aws_identitystore_user.owner.user_id
  principal_type = "USER"

  target_id   = aws_organizations_account.build.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "admin_access_dev_build_owner" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn

  principal_id   = aws_identitystore_user.owner.user_id
  principal_type = "USER"

  target_id   = aws_organizations_account.dev-build.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "admin_access_audit_owner" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn

  principal_id   = aws_identitystore_user.owner.user_id
  principal_type = "USER"

  target_id   = aws_organizations_account.audit.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_identitystore_group_membership" "billing_full_access_owner" {
  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.billing_full_access_group.group_id
  member_id         = aws_identitystore_user.owner.user_id
}

data "aws_identitystore_group_memberships" "example" {
  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.billing_full_access_group.group_id
}

output "debug" {
  value = data.aws_identitystore_group_memberships.terraform_state_access
}
