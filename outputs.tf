##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "project_name" {
  value = mongodbatlas_project.this.name
}

output "project_id" {
  value = mongodbatlas_project.this.id
}

output "project_creation_timestamp" {
  value = mongodbatlas_project.this.created
}

output "project_backup_policy_id" {
  value = try(var.settings.backup_compliance.enabled, false) ? mongodbatlas_backup_compliance_policy.this[0].id : null
}

output "project_kms_iam_role_name" {
  value = try(var.settings.encryption_at_rest.enabled, false) ? aws_iam_role.kms[0].name : null
}

output "project_kms_iam_role_arn" {
  value = try(var.settings.encryption_at_rest.enabled, false) ? aws_iam_role.kms[0].arn : null
}

output "project_kms_key_id" {
  value = try(var.settings.encryption_at_rest.enabled, false) ? aws_kms_key.kms[0].id : null
}

output "project_kms_key_arn" {
  value = try(var.settings.encryption_at_rest.enabled, false) ? aws_kms_key.kms[0].arn : null
}

output "project_kms_key_alias" {
  value = try(var.settings.encryption_at_rest.enabled, false) ? aws_kms_alias.kms[0].name : null
}