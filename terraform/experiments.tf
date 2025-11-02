resource "aws_organizations_organizational_unit" "experiments" {
  name      = "experiments"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_account" "build" {
  name  = "build"
  email = "aws+build@murraytait.com"
  tags = {
    "build"           = "build"
    "dns"             = "Murray Tait"
    "terraform-state" = "build"
  }
  parent_id = aws_organizations_organizational_unit.experiments.id
}

resource "aws_organizations_account" "dev-build" {
  name  = "dev-build"
  email = "aws+dev-build@murraytait.com"
  tags = {
    "build"           = "build"
    "dns"             = "Murray Tait"
    "terraform-state" = "build"
  }
  parent_id = aws_organizations_organizational_unit.experiments.id
}

resource "aws_organizations_account" "endtoend" {
  name  = "endtoend"
  email = "aws+endtoend@murraytait.com"
  tags = {
    "build"           = "build"
    "dns"             = "Murray Tait"
    "terraform_state" = "build"
  }
  parent_id = aws_organizations_organizational_unit.experiments.id
}


resource "aws_organizations_account" "dev1" {
  name  = "dev1"
  email = "aws+dev1@murraytait.com"
  tags = {
    "build"           = "build"
    "dns"             = "Murray Tait"
    "terraform_state" = "build"
  }
  parent_id = aws_organizations_organizational_unit.experiments.id
}

resource "aws_identitystore_group" "developers" {
  display_name      = "Developers"
  description       = "Application Developers"
  identity_store_id = local.identity_store_id
}
