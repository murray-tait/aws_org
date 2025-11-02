resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "controltower.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "sso.amazonaws.com",
  ]
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]
  feature_set = "ALL"
}

locals {
  parent_organization_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_policy_attachment" "full_access_policy_root" {
  policy_id = "p-FullAWSAccess"
  target_id = local.parent_organization_id
}

resource "aws_organizations_organizational_unit" "core" {
  name      = "Core"
  parent_id = local.parent_organization_id
}

resource "aws_organizations_account" "account" {
  name  = "Murray Tait"
  email = "murray_tait@hotmail.com"
}

resource "aws_organizations_account" "log_archive" {
  name      = "Log archive"
  email     = "aws+log-archive@murraytait.com"
  parent_id = aws_organizations_organizational_unit.core.id
}

data "aws_ssoadmin_instances" "this" {}

locals {
  identity_store_id  = data.aws_ssoadmin_instances.this.identity_store_ids[0]
  identity_store_arn = data.aws_ssoadmin_instances.this.arns[0]
}

resource "aws_identitystore_group" "aws_account_factory" {
  display_name      = "AWSAccountFactory"
  description       = "Read-only access to account factory in AWS Service Catalog for end users"
  identity_store_id = local.identity_store_id
}

resource "aws_ssoadmin_account_assignment" "aws_account_factory" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.aws_service_catalog_end_user_access.arn

  principal_id   = aws_identitystore_group.aws_account_factory.group_id
  principal_type = "GROUP"

  target_id   = aws_organizations_account.account.id
  target_type = "AWS_ACCOUNT"
}

import {
  to = aws_ssoadmin_account_assignment.aws_account_factory
  id = "936703532d-42c17171-73d8-4ee4-8074-db1d74c4df44,GROUP,453254632971,AWS_ACCOUNT,${aws_ssoadmin_permission_set.aws_service_catalog_end_user_access.arn},${local.identity_store_arn}"
}

resource "aws_identitystore_group" "billing_full_access_group" {
  display_name      = "BillingFullAccessGroup"
  description       = null
  identity_store_id = local.identity_store_id
}

resource "aws_identitystore_group" "aws_control_tower_admins" {
  display_name      = "AWSControlTowerAdmins"
  description       = "Admin rights to AWS Control Tower core and provisioned accounts"
  identity_store_id = local.identity_store_id
}

resource "aws_identitystore_group" "aws_log_archive_admins" {
  display_name      = "AWSLogArchiveAdmins"
  description       = "Admin rights to log archive account"
  identity_store_id = local.identity_store_id
}

resource "aws_ssoadmin_account_assignment" "aws_log_archive_admins" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn

  principal_id   = aws_identitystore_group.aws_log_archive_admins.group_id
  principal_type = "GROUP"

  target_id   = aws_organizations_account.log_archive.id
  target_type = "AWS_ACCOUNT"
}

import {
  to = aws_ssoadmin_account_assignment.aws_log_archive_admins
  id = "936703532d-07661f96-71a3-4770-a24d-4852480d668b,GROUP,971370808066,AWS_ACCOUNT,${aws_ssoadmin_permission_set.admin_access.arn},${local.identity_store_arn}"
}

resource "aws_identitystore_group" "aws_environment_full_access" {
  display_name      = "AWSEnvironmentFullAccess"
  description       = null
  identity_store_id = local.identity_store_id
}

resource "aws_identitystore_group" "aws_log_archive_viewers" {
  display_name      = "AWSLogArchiveViewers"
  description       = "Read-only access to log archive account"
  identity_store_id = local.identity_store_id
}

