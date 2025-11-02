
resource "aws_ssoadmin_permission_set" "network_admin" {
  name             = "NetworkAdministrator"
  instance_arn     = local.identity_store_arn
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "network_admin_network_admin" {
  instance_arn       = local.identity_store_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
  permission_set_arn = aws_ssoadmin_permission_set.network_admin.arn
}
