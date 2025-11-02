resource "aws_ssoadmin_permission_set" "admin_access" {
  name             = "AWSAdministratorAccess"
  instance_arn     = local.identity_store_arn
  description      = "Provides full access to AWS services and resources"
  session_duration = "PT8H"
}

resource "aws_ssoadmin_account_assignment" "admin_access_audit" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn

  principal_id   = aws_identitystore_group.aws_control_tower_admins.group_id
  principal_type = "GROUP"

  target_id   = aws_organizations_account.audit.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_managed_policy_attachment" "admin_access_admin_access" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "admin_access_aws_billing_read_only_access" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "admin_access_billing" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn
}

resource "aws_ssoadmin_permission_set" "aws_power_user_access" {
  name             = "AWSPowerUserAccess"
  instance_arn     = local.identity_store_arn
  description      = "Provides full access to AWS services and resources, but does not allow management of Users and groups"
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_power_user_access_admin_access" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.aws_power_user_access.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_power_user_access_aws_organization_full_access" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSOrganizationsFullAccess"
  permission_set_arn = aws_ssoadmin_permission_set.aws_power_user_access.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_power_user_access_power_user_access" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  permission_set_arn = aws_ssoadmin_permission_set.aws_power_user_access.arn
}

resource "aws_ssoadmin_permission_set" "aws_organizations_full_access" {
  name             = "AWSOrganizationsFullAccess"
  instance_arn     = local.identity_store_arn
  description      = "Provides full access to AWS Organizations"
  session_duration = "PT1H"
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_organizations_full_access_aws_organizations_full_access" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSOrganizationsFullAccess"
  permission_set_arn = aws_ssoadmin_permission_set.aws_organizations_full_access.arn
}

resource "aws_ssoadmin_permission_set" "aws_read_only" {
  name             = "AWSReadOnlyAccess"
  instance_arn     = local.identity_store_arn
  description      = "This policy grants permissions to view resources and basic metadata across all AWS services"
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_read_only_view_only_access" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.aws_read_only.arn
}

