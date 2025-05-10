## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_mongodbatlas"></a> [mongodbatlas](#provider\_mongodbatlas) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [mongodbatlas_backup_compliance_policy.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/backup_compliance_policy) | resource |
| [mongodbatlas_cloud_provider_access_authorization.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cloud_provider_access_authorization) | resource |
| [mongodbatlas_cloud_provider_access_setup.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cloud_provider_access_setup) | resource |
| [mongodbatlas_encryption_at_rest.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/encryption_at_rest) | resource |
| [mongodbatlas_maintenance_window.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/maintenance_window) | resource |
| [mongodbatlas_project.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project) | resource |
| [mongodbatlas_project_ip_access_list.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list) | resource |
| [aws_iam_policy_document.kms_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [mongodbatlas_organizations.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/data-sources/organizations) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Establish this is a HUB or spoke configuration | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for the name of the resources | `string` | `""` | no |
| <a name="input_org"></a> [org](#input\_org) | n/a | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | (optional) The ID of the organization where the project will be created | `string` | `""` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | (optional) The name of the organization where the project will be created | `string` | `""` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | (optional) The backup compliance policy | `any` | `{}` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | n/a | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_backup_policy_id"></a> [project\_backup\_policy\_id](#output\_project\_backup\_policy\_id) | n/a |
| <a name="output_project_creation_timestamp"></a> [project\_creation\_timestamp](#output\_project\_creation\_timestamp) | n/a |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | n/a |
| <a name="output_project_kms_iam_role_arn"></a> [project\_kms\_iam\_role\_arn](#output\_project\_kms\_iam\_role\_arn) | n/a |
| <a name="output_project_kms_iam_role_name"></a> [project\_kms\_iam\_role\_name](#output\_project\_kms\_iam\_role\_name) | n/a |
| <a name="output_project_kms_key_alias"></a> [project\_kms\_key\_alias](#output\_project\_kms\_key\_alias) | n/a |
| <a name="output_project_kms_key_arn"></a> [project\_kms\_key\_arn](#output\_project\_kms\_key\_arn) | n/a |
| <a name="output_project_kms_key_id"></a> [project\_kms\_key\_id](#output\_project\_kms\_key\_id) | n/a |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | n/a |
