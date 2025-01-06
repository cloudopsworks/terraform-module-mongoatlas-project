##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  atlas_region = upper(replace(data.aws_region.current.name, "-", "_"))
}

resource "mongodbatlas_cloud_provider_access_setup" "this" {
  count         = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  project_id    = mongodbatlas_project.this.id
  provider_name = "AWS"
}

resource "mongodbatlas_cloud_provider_access_authorization" "this" {
  count      = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  project_id = mongodbatlas_project.this.id
  role_id    = mongodbatlas_cloud_provider_access_setup.this[count.index].role_id
  aws {
    iam_assumed_role_arn = aws_iam_role.kms[count.index].arn
  }
}

resource "mongodbatlas_encryption_at_rest" "this" {
  count      = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  project_id = mongodbatlas_project.this.id
  aws_kms_config {
    enabled                = true
    customer_master_key_id = aws_kms_key.kms[count.index].arn
    region                 = local.atlas_region
    role_id                = mongodbatlas_cloud_provider_access_authorization.this[count.index].role_id
  }
}

data "aws_iam_policy_document" "kms_assume_role" {
  count = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [mongodbatlas_cloud_provider_access_setup.this[count.index].aws_config[0].atlas_aws_account_arn]
    }
    condition {
      test     = "StringEquals"
      values   = [mongodbatlas_cloud_provider_access_setup.this[count.index].aws_config[0].atlas_assumed_role_external_id]
      variable = "sts:ExternalId"
    }
  }
}

resource "aws_iam_role" "kms" {
  count              = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  name               = "mongodbatlas-${local.system_name}-kms"
  assume_role_policy = data.aws_iam_policy_document.kms_assume_role[count.index].json
  tags               = local.all_tags
}

data "aws_iam_policy_document" "kms_policy" {
  count = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:ReEncrypt*",
      "kms:ListRetirableGrants",
      "kms:Describe*",
      "kms:List*"
    ]
    resources = [aws_kms_key.kms[count.index].arn]
  }
}

resource "aws_iam_role_policy" "kms" {
  count  = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  role   = aws_iam_role.kms[count.index].name
  policy = data.aws_iam_policy_document.kms_policy[count.index].json
}

resource "aws_kms_key" "kms" {
  count                   = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  description             = "KMS key for MongoDB Atlas - ${local.atlas_name}"
  deletion_window_in_days = try(var.settings.encryption_at_rest.deletion_window_in_days, 7)
  enable_key_rotation     = try(var.settings.encryption_at_rest.enable_key_rotation, true)
  rotation_period_in_days = try(var.settings.encryption_at_rest.rotation_period_in_days, 90)
  multi_region            = try(var.settings.encryption_at_rest.multi_region, false)
  tags = merge(
    {
      Name = format("mongodbatlas-%s-kms", local.system_name)
    },
    local.all_tags
  )
}

resource "aws_kms_alias" "kms" {
  count         = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  name          = format("alias/mongodbatlas-%s-kms", local.system_name)
  target_key_id = aws_kms_key.kms[count.index].id
}