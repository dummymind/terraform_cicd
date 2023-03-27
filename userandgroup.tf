#user and policy and s3 bucket


data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.bucket.arn]
    effect = "Allow"
  }
}


resource "aws_iam_user" "terraform_new_user" {
  name = "terraform_new_user"
}

resource "aws_iam_access_key" "my_access_key" {
  user = aws_iam_user.terraform_new_user.name
}


resource "random_pet" "pet_name" {
  length    = 3
  separator = "-"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${random_pet.pet_name.id}-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Testing_Env"
  }
}


resource "aws_iam_policy" "policy" {
  name        = "${random_pet.pet_name.id}-policy"
  description = "My test policy"
  policy = data.aws_iam_policy_document.s3_policy.json
}

output "rendered_policy" {
  value = data.aws_iam_policy_document.s3_policy.json
}

output "secret" {
  value = aws_iam_access_key.my_access_key.encrypted_secret
  sensitive = true
}  


#group and group membership

resource "aws_iam_group" "terraform_custom_group" {
  name = "TerraformCustomGroup"
}

resource "aws_iam_group_policy_attachment" "custom_policy" {
  group      = aws_iam_group.terraform_custom_group.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [
    aws_iam_user.terraform_new_user.name,
  ]

  group = aws_iam_group.terraform_custom_group.name
}


#role and iam_policy


data "aws_iam_policy_document" "t_assume_role" {
  effect = "Allow"

  principals {
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
  }

  actions = ["sts:AssumeRole"]
}

resource "aws_iam_role" "t_role" {
  name               = "t_test-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "t_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "t_policy" {
  name        = "t_test-policy"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.t_policy.json
}

resource "aws_iam_role_policy_attachment" "t_test-attach" {
  role       = aws_iam_role.t_role.name
  policy_arn = aws_iam_policy.t_policy.arn
}