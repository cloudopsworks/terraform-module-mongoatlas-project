##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "project_name" {
  description = "Resolved MongoDB Atlas project name"
  value       = mongodbatlas_project.this.name
}

output "project_id" {
  description = "MongoDB Atlas project ID"
  value       = mongodbatlas_project.this.id
}

output "project_creation_timestamp" {
  description = "ISO-8601 timestamp of when the Atlas project was created"
  value       = mongodbatlas_project.this.created
}

output "project_backup_policy_id" {
  description = "Backup compliance policy ID; null when backup compliance is disabled"
  value       = try(var.settings.backup_compliance.enabled, false) ? mongodbatlas_backup_compliance_policy.this[0].id : null
}

output "cloud_provider_setup_role_id" {
  description = "MongoDB Atlas role ID from the cloud provider access setup"
  value       = try(mongodbatlas_cloud_provider_access_setup.this[0].role_id, null)
}

output "cloud_provider_setup_aws_account_arn" {
  description = "Atlas AWS account ARN used for the IAM trust relationship (AWS)"
  value       = try(mongodbatlas_cloud_provider_access_setup.this[0].aws_config[0].atlas_aws_account_arn, null)
}

output "cloud_provider_setup_aws_external_id" {
  description = "Atlas external ID for the IAM STS AssumeRole condition (AWS)"
  value       = try(mongodbatlas_cloud_provider_access_setup.this[0].aws_config[0].atlas_assumed_role_external_id, null)
}

output "cloud_provider_setup_gcp_service_account" {
  description = "Atlas GCP service account email — grant this SA roles/cloudkms.cryptoKeyEncrypterDecrypter on the KMS key (GCP)"
  value       = try(mongodbatlas_cloud_provider_access_setup.this[0].gcp_config[0].service_account_for_atlas, null)
}

output "cloud_provider_setup_azure_app_id" {
  description = "Atlas Azure application ID — used as client_id in the Key Vault encryption config (AZURE)"
  value       = try(mongodbatlas_cloud_provider_access_setup.this[0].azure_config[0].atlas_azure_app_id, null)
}

output "cloud_provider_setup_azure_service_principal_id" {
  description = "Atlas Azure service principal object ID — grant this SP access to the Key Vault (AZURE)"
  value       = try(mongodbatlas_cloud_provider_access_setup.this[0].azure_config[0].service_principal_id, null)
}

output "cloud_provider_setup_azure_tenant_id" {
  description = "Azure AD tenant ID associated with the Atlas service principal (AZURE)"
  value       = try(mongodbatlas_cloud_provider_access_setup.this[0].azure_config[0].tenant_id, null)
}

output "encryption_at_rest_id" {
  description = "MongoDB Atlas encryption-at-rest configuration ID"
  value       = try(mongodbatlas_encryption_at_rest.this[0].id, null)
}

output "all_alert_configurations" {
  description = "Raw alert configurations fetched from the project (used by cloud-specific modules for provider-specific alert import)"
  value       = data.mongodbatlas_alert_configurations.import.results
}
