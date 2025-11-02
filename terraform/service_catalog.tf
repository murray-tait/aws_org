
resource "aws_identitystore_group" "aws_service_catalog_admins" {
  display_name      = "AWSServiceCatalogAdmins"
  description       = "Admin rights to account factory in AWS Service Catalog"
  identity_store_id = local.identity_store_id
}

resource "aws_ssoadmin_permission_set" "aws_service_catalog_admin_full_access" {
  name             = "AWSServiceCatalogAdminFullAccess"
  description      = "Provides full access to AWS Service Catalog admin capabilities"
  instance_arn     = local.identity_store_arn
  session_duration = "PT1H"
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_service_catalog_admin_full_access" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSServiceCatalogAdminFullAccess"
  permission_set_arn = aws_ssoadmin_permission_set.aws_service_catalog_admin_full_access.arn
}

resource "aws_ssoadmin_account_assignment" "aws_service_catalog_admins" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.aws_service_catalog_admin_full_access.arn

  principal_id   = aws_identitystore_group.aws_service_catalog_admins.group_id
  principal_type = "GROUP"

  target_id   = aws_organizations_account.account.id
  target_type = "AWS_ACCOUNT"
}

import {
  to = aws_ssoadmin_account_assignment.aws_service_catalog_admins
  id = "936703532d-339740b1-0095-415c-b7b9-d64896455691,GROUP,453254632971,AWS_ACCOUNT,${aws_ssoadmin_permission_set.aws_service_catalog_admin_full_access.arn},${local.identity_store_arn}"
}

resource "aws_ssoadmin_permission_set" "aws_service_catalog_end_user_access" {
  name             = "AWSServiceCatalogEndUserAccess"
  description      = "Provides access to the AWS Service Catalog end user console"
  instance_arn     = local.identity_store_arn
  session_duration = "PT1H"
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_service_catalog_end_user_access" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSServiceCatalogEndUserFullAccess"
  permission_set_arn = aws_ssoadmin_permission_set.aws_service_catalog_end_user_access.arn
}
