resource "aws_identitystore_group" "terraform_state_access" {
  display_name      = "TerraformStateAccess"
  description       = "Gives access to the terraform state"
  identity_store_id = local.identity_store_id
}

resource "aws_ssoadmin_permission_set" "terraform_state_access" {
  name             = "TerraformStateAccess"
  instance_arn     = local.identity_store_arn
  session_duration = "PT8H"
}

resource "aws_ssoadmin_account_assignment" "terraform_state_access" {
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_state_access.arn

  principal_id   = aws_identitystore_group.terraform_state_access.group_id
  principal_type = "GROUP"

  target_id   = aws_organizations_account.build.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_managed_policy_attachment" "terraform_state_access" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  permission_set_arn = aws_ssoadmin_permission_set.terraform_state_access.arn
}

