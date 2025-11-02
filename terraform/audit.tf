resource "aws_organizations_account" "audit" {
  name      = "Audit"
  email     = "aws+audit@murraytait.com"
  parent_id = aws_organizations_organizational_unit.core.id
}

resource "aws_identitystore_group" "aws_audit_account_admins" {
  display_name      = "AWSAuditAccountAdmins"
  description       = "Admin rights to cross-account audit account"
  identity_store_id = local.identity_store_id
}

resource "aws_ssoadmin_account_assignment" "aws_audit_account_admins_admin_access_audit" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn

  principal_id   = aws_identitystore_group.aws_audit_account_admins.group_id
  principal_type = "GROUP"

  target_id   = aws_organizations_account.audit.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "aws_audit_account_admins" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn

  principal_id   = aws_identitystore_group.aws_audit_account_admins.group_id
  principal_type = "GROUP"

  target_id   = aws_organizations_account.audit.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_identitystore_group" "aws_security_audit_power_users" {
  display_name      = "AWSSecurityAuditPowerUsers"
  description       = "Power user access to all accounts for security audits"
  identity_store_id = local.identity_store_id
}

resource "aws_ssoadmin_account_assignment" "aws_security_audit_power_users_audit_account" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.aws_power_user_access.arn

  principal_id   = aws_identitystore_group.aws_security_audit_power_users.group_id
  principal_type = "GROUP"

  target_id   = aws_organizations_account.audit.id
  target_type = "AWS_ACCOUNT"
}

import {
  to = aws_ssoadmin_account_assignment.aws_security_audit_power_users_audit_account
  id = "${aws_identitystore_group.aws_security_audit_power_users.group_id},GROUP,${aws_organizations_account.audit.id},AWS_ACCOUNT,${aws_ssoadmin_permission_set.aws_power_user_access.arn},${local.identity_store_arn}"
}

resource "aws_identitystore_group" "aws_security_auditors" {
  display_name      = "AWSSecurityAuditors"
  description       = "Read-only access to all accounts for security audits"
  identity_store_id = local.identity_store_id
}

