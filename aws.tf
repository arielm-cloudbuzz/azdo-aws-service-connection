locals {
  name = "azure_devops"
}


resource "aws_iam_user" "this" {
  name                 = coalesce(var.iam_user["name"], local.name)
  path                 = lookup(var.iam_user, "path", null)
  permissions_boundary = lookup(var.iam_user, "permissions_boundary", null)
  force_destroy        = lookup(var.iam_user, "force_destroy", false)

  tags = lookup(var.iam_user, "tags", {})
}


resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}


resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.this.arn]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [random_password.this.result]
    }
  }
}


resource "aws_iam_role" "this" {
  name                 = lookup(var.iam_role, "name", local.name)
  path                 = var.iam_role["path"]
  permissions_boundary = var.iam_role["permissions_boundary"]
  assume_role_policy   = lookup(var.iam_role, "assume_role_policy", data.aws_iam_policy_document.assume_role_policy.json)
  description          = var.iam_role["description"]
  max_session_duration = var.iam_role["max_session_duration"]

  tags = var.iam_role["tags"]
}


data "aws_iam_policy_document" "iam_user_policy" {
  statement {
    resources = [aws_iam_role.this.arn]
    actions   = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [random_password.this.result]
    }
  }
}


resource "aws_iam_user_policy" "this" {
  name   = "assume_role_${local.name}"
  user   = aws_iam_user.this.name
  policy = data.aws_iam_policy_document.iam_user_policy.json
}
