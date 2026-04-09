##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#
# Generic cloud-provider access and encryption-at-rest management.
# Supports AWS, GCP, and AZURE via dynamic blocks.
# Cloud-specific infrastructure resources (KMS keys, Key Vaults) remain
# in the respective cloud modules; only MongoDB Atlas provider resources live here.
#
# Dependency note:
#   local.encryption_provider is derived from var.encryption_provider (a plain string),
#   not from var.encryption_provider_config (which contains cloud resource references).
#   This breaks any resource-level cycle: access_setup.count has no dependency on
#   cloud resources, so cloud modules can safely reference access_setup outputs
#   (e.g. gcp_service_account_for_atlas, azure_config) to build their own resources,
#   whose attributes are then passed back via var.encryption_provider_config.
#

locals {
  encryption_enabled  = try(var.settings.encryption_at_rest.enabled, false)
  encryption_provider = upper(var.encryption_provider)
}

# Register Atlas with the cloud provider and obtain provider-specific identifiers:
#   AWS   → atlas_aws_account_arn + atlas_assumed_role_external_id (for IAM trust policy)
#   GCP   → gcp_config[0].service_account_for_atlas (grant this SA access to the KMS key)
#   AZURE → azure_config: atlas_azure_app_id + service_principal_id + tenant_id
resource "mongodbatlas_cloud_provider_access_setup" "this" {
  count         = local.encryption_enabled && local.encryption_provider != "" ? 1 : 0
  project_id    = mongodbatlas_project.this.id
  provider_name = local.encryption_provider
}

# Authorize the cloud-provider identity to act on behalf of Atlas.
resource "mongodbatlas_cloud_provider_access_authorization" "this" {
  count      = local.encryption_enabled && local.encryption_provider != "" ? 1 : 0
  project_id = mongodbatlas_project.this.id
  role_id    = mongodbatlas_cloud_provider_access_setup.this[count.index].role_id

  # AWS: IAM role ARN provided by the cloud module after the trust policy is applied.
  dynamic "aws" {
    for_each = local.encryption_provider == "AWS" ? [1] : []
    content {
      iam_assumed_role_arn = var.encryption_provider_config.iam_assumed_role_arn
    }
  }

  # GCP: No input block needed — authorization is confirmed implicitly once the Atlas
  # service account (gcp_config[0].service_account_for_atlas) has been granted KMS access.

  # AZURE: All values come from the setup resource (Atlas manages its own Azure app/SP).
  dynamic "azure" {
    for_each = local.encryption_provider == "AZURE" ? [1] : []
    content {
      atlas_azure_app_id   = mongodbatlas_cloud_provider_access_setup.this[0].azure_config[0].atlas_azure_app_id
      service_principal_id = mongodbatlas_cloud_provider_access_setup.this[0].azure_config[0].service_principal_id
      tenant_id            = mongodbatlas_cloud_provider_access_setup.this[0].azure_config[0].tenant_id
    }
  }
}

# Configure encryption at rest for AWS / GCP / Azure.
# depends_on ensures authorization completes before encryption is configured.
# For AWS, the role_id reference already creates an implicit ordering;
# for GCP and Azure it is enforced via depends_on.
resource "mongodbatlas_encryption_at_rest" "this" {
  count      = local.encryption_enabled ? 1 : 0
  project_id = mongodbatlas_project.this.id

  depends_on = [mongodbatlas_cloud_provider_access_authorization.this]

  dynamic "aws_kms_config" {
    for_each = local.encryption_provider == "AWS" ? [1] : []
    content {
      enabled                = true
      customer_master_key_id = var.encryption_provider_config.customer_master_key_id
      region                 = var.encryption_provider_config.region
      role_id                = mongodbatlas_cloud_provider_access_authorization.this[0].role_id
    }
  }

  # GCP: uses the Atlas-managed service account (cloud provider access).
  # No service_account_key needed; authentication is via the authorized SA.
  dynamic "google_cloud_kms_config" {
    for_each = local.encryption_provider == "GCP" ? [1] : []
    content {
      enabled                 = true
      key_version_resource_id = var.encryption_provider_config.key_version_resource_id
    }
  }

  # AZURE: uses the Atlas-managed service principal (cloud provider access).
  # client_id and tenant_id come from the setup resource; no secret required.
  dynamic "azure_key_vault_config" {
    for_each = local.encryption_provider == "AZURE" ? [1] : []
    content {
      enabled             = true
      azure_environment   = try(var.encryption_provider_config.azure_environment, "AZURE")
      client_id           = mongodbatlas_cloud_provider_access_setup.this[0].azure_config[0].atlas_azure_app_id
      subscription_id     = var.encryption_provider_config.subscription_id
      resource_group_name = var.encryption_provider_config.resource_group_name
      key_vault_name      = var.encryption_provider_config.key_vault_name
      key_identifier      = var.encryption_provider_config.key_identifier
      tenant_id           = mongodbatlas_cloud_provider_access_setup.this[0].azure_config[0].tenant_id
    }
  }
}
