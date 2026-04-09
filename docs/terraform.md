## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_mongodbatlas"></a> [mongodbatlas](#requirement\_mongodbatlas) | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_mongodbatlas"></a> [mongodbatlas](#provider\_mongodbatlas) | 2.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [mongodbatlas_alert_configuration.alert](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/alert_configuration) | resource |
| [mongodbatlas_backup_compliance_policy.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/backup_compliance_policy) | resource |
| [mongodbatlas_cloud_provider_access_authorization.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cloud_provider_access_authorization) | resource |
| [mongodbatlas_cloud_provider_access_setup.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cloud_provider_access_setup) | resource |
| [mongodbatlas_encryption_at_rest.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/encryption_at_rest) | resource |
| [mongodbatlas_maintenance_window.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/maintenance_window) | resource |
| [mongodbatlas_project.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project) | resource |
| [mongodbatlas_project_ip_access_list.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list) | resource |
| [mongodbatlas_alert_configurations.import](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/data-sources/alert_configurations) | data source |
| [mongodbatlas_organizations.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/data-sources/organizations) | data source |
| [mongodbatlas_roles_org_id.current](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/data-sources/roles_org_id) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_encryption_provider"></a> [encryption\_provider](#input\_encryption\_provider) | (Optional) Cloud provider for encryption at rest. Values: AWS, GCP, AZURE. Passed separately from encryption\_provider\_config to avoid Terraform dependency cycles. | `string` | `""` | no |
| <a name="input_encryption_provider_config"></a> [encryption\_provider\_config](#input\_encryption\_provider\_config) | (Optional) Cloud-provider-specific encryption configuration passed from the cloud module. AWS: IAM role ARN + KMS key ARN + region. GCP: KMS key version resource ID. AZURE: subscription ID + resource group + key vault name + key identifier. Auth identifiers (GCP SA email, Azure app/SP/tenant) are sourced from mongodbatlas\_cloud\_provider\_access\_setup outputs. | `any` | `{}` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_generate_import"></a> [generate\_import](#input\_generate\_import) | (Optional) Generate OpenTofu import blocks for existing Atlas resources | `bool` | `false` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) Explicit name for the MongoDB Atlas project; overrides name\_prefix | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | (Optional) Prefix for the name of the resources | `string` | `""` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | (Optional) The ID of the MongoDB Atlas organization where the project will be created | `string` | `""` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | (Optional) The name of the MongoDB Atlas organization where the project will be created | `string` | `""` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | (Optional) Module settings object controlling project features: backup compliance, maintenance window, IP access list, and alert configurations | `any` | `{}` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_alert_configurations"></a> [all\_alert\_configurations](#output\_all\_alert\_configurations) | Raw alert configurations fetched from the project (used by cloud-specific modules for provider-specific alert import) |
| <a name="output_cloud_provider_setup_aws_account_arn"></a> [cloud\_provider\_setup\_aws\_account\_arn](#output\_cloud\_provider\_setup\_aws\_account\_arn) | Atlas AWS account ARN used for the IAM trust relationship (AWS) |
| <a name="output_cloud_provider_setup_aws_external_id"></a> [cloud\_provider\_setup\_aws\_external\_id](#output\_cloud\_provider\_setup\_aws\_external\_id) | Atlas external ID for the IAM STS AssumeRole condition (AWS) |
| <a name="output_cloud_provider_setup_azure_app_id"></a> [cloud\_provider\_setup\_azure\_app\_id](#output\_cloud\_provider\_setup\_azure\_app\_id) | Atlas Azure application ID — used as client\_id in the Key Vault encryption config (AZURE) |
| <a name="output_cloud_provider_setup_azure_service_principal_id"></a> [cloud\_provider\_setup\_azure\_service\_principal\_id](#output\_cloud\_provider\_setup\_azure\_service\_principal\_id) | Atlas Azure service principal object ID — grant this SP access to the Key Vault (AZURE) |
| <a name="output_cloud_provider_setup_azure_tenant_id"></a> [cloud\_provider\_setup\_azure\_tenant\_id](#output\_cloud\_provider\_setup\_azure\_tenant\_id) | Azure AD tenant ID associated with the Atlas service principal (AZURE) |
| <a name="output_cloud_provider_setup_gcp_service_account"></a> [cloud\_provider\_setup\_gcp\_service\_account](#output\_cloud\_provider\_setup\_gcp\_service\_account) | Atlas GCP service account email — grant this SA roles/cloudkms.cryptoKeyEncrypterDecrypter on the KMS key (GCP) |
| <a name="output_cloud_provider_setup_role_id"></a> [cloud\_provider\_setup\_role\_id](#output\_cloud\_provider\_setup\_role\_id) | MongoDB Atlas role ID from the cloud provider access setup |
| <a name="output_encryption_at_rest_id"></a> [encryption\_at\_rest\_id](#output\_encryption\_at\_rest\_id) | MongoDB Atlas encryption-at-rest configuration ID |
| <a name="output_imported_alert_json"></a> [imported\_alert\_json](#output\_imported\_alert\_json) | n/a |
| <a name="output_imported_alert_statement"></a> [imported\_alert\_statement](#output\_imported\_alert\_statement) | n/a |
| <a name="output_project_backup_policy_id"></a> [project\_backup\_policy\_id](#output\_project\_backup\_policy\_id) | n/a |
| <a name="output_project_creation_timestamp"></a> [project\_creation\_timestamp](#output\_project\_creation\_timestamp) | n/a |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | n/a |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | n/a |
