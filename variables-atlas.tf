##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "name_prefix" {
  # (Optional) Prefix prepended to the auto-generated project name when `name` is not set. Default: "".
  description = "(Optional) Prefix for the name of the resources"
  type        = string
  default     = ""
}

variable "name" {
  # (Optional) Explicit name for the MongoDB Atlas project. When set, overrides `name_prefix`. Default: "".
  description = "(Optional) Explicit name for the MongoDB Atlas project; overrides name_prefix"
  type        = string
  default     = ""
}

variable "organization_name" {
  # (Optional) Name of the MongoDB Atlas organization. Used to look up the org ID when `organization_id` is not provided.
  description = "(Optional) The name of the MongoDB Atlas organization where the project will be created"
  type        = string
  default     = ""
}

variable "organization_id" {
  # (Optional) Direct MongoDB Atlas organization ID. Takes precedence over `organization_name` lookup.
  description = "(Optional) The ID of the MongoDB Atlas organization where the project will be created"
  type        = string
  default     = ""
}

## Settings object structure (all keys are optional unless noted):
#
# settings:
#   default_alerts_settings: true | false          # (Optional) Enable default alert settings for the project.
#   collect_database_specifics_statistics_enabled: true | false  # (Optional) Collect database-specific statistics.
#   data_explorer_enabled: true | false            # (Optional) Enable Data Explorer.
#   extended_storage_sizes_enabled: true | false   # (Optional) Enable extended storage sizes.
#   performance_advisor_enabled: true | false      # (Optional) Enable Performance Advisor.
#   schema_advisor_enabled: true | false           # (Optional) Enable Schema Advisor.
#
#   backup_compliance:
#     enabled: true | false                        # (Optional) Enable backup compliance policy. Default: false.
#     authorized_user:
#       email: string                              # (Required) Email of the authorized user.
#       first_name: string                         # (Required) First name of the authorized user.
#       last_name: string                          # (Required) Last name of the authorized user.
#     copy_protection_enabled: true | false        # (Optional) Enable copy protection. Default: false.
#     pit_enabled: true | false                    # (Optional) Enable Point-in-Time recovery. Default: false.
#     encryption_at_rest_enabled: true | false     # (Optional) Require encryption at rest. Default: false.
#     restore_window_days: number                  # (Optional) Restore window in days. Default: 7.
#     hourly:
#       interval: number                           # (Optional) Frequency interval (hours). Default: 1.
#       retention_unit: string                     # (Optional) Retention unit. Values: "days". Default: "days".
#       retention_value: number                    # (Optional) Retention value. Default: 1.
#     daily:
#       interval: number                           # (Optional) Frequency interval (days). Default: 1.
#       retention_unit: string                     # (Optional) Retention unit. Values: "days". Default: "days".
#       retention_value: number                    # (Optional) Retention value. Default: 7.
#     weekly:
#       interval: number                           # (Optional) Day of week (1=Sunday … 7=Saturday). Default: 1.
#       retention_unit: string                     # (Optional) Retention unit. Values: "weeks". Default: "weeks".
#       retention_value: number                    # (Optional) Retention value. Default: 4.
#     monthly:
#       interval: number                           # (Optional) Day of month (1–28). Default: 1.
#       retention_unit: string                     # (Optional) Retention unit. Values: "months". Default: "months".
#       retention_value: number                    # (Optional) Retention value. Default: 12.
#     yearly:
#       interval: number                           # (Optional) Month of year (1–12). Default: 1.
#       retention_unit: string                     # (Optional) Retention unit. Values: "years". Default: "years".
#       retention_value: number                    # (Optional) Retention value. Default: 2.
#     on_demand:
#       interval: number                           # (Optional) Must be 0. Default: 1.
#       retention_unit: string                     # (Optional) Retention unit. Values: "days". Default: "days".
#       retention_value: number                    # (Optional) Retention value. Default: 7.
#
#   maintenance:
#     enabled: true | false                        # (Optional) Enable maintenance window. Default: false.
#     day_of_week: number                          # (Optional) Day of week (1=Sunday … 7=Saturday). Default: 1.
#     hour_of_day: number                          # (Optional) Hour of day in UTC (0–23). Default: 0.
#     defer: true | false                          # (Optional) Defer the next scheduled maintenance. Default: null.
#     auto_defer: true | false                     # (Optional) Auto-defer maintenance. Default: null.
#     auto_defer_once_enabled: true | false        # (Optional) Enable auto-defer once. Default: null.
#
#   access_list:                                   # (Optional) Map of IP access list entries keyed by a unique ID.
#     <id>:
#       comment: string                            # (Optional) Human-readable comment for the entry.
#       ip_address: string                         # (Optional) Single IP address. Conflicts with cidr_block and aws_security_group.
#       aws_security_group: string                 # (Optional) AWS security group ID. Conflicts with ip_address and cidr_block.
#       cidr_block: string                         # (Optional) CIDR block. Conflicts with ip_address and aws_security_group.
#
#   excluded_alert_event_types: list(string)       # (Optional) Alert event types to exclude from the managed alert for_each (used by cloud-specific modules to prevent conflicts with their own managed alerts). Default: [].
#
#   alerts:                                        # (Optional) List of alert configurations.
#     - event_type: string                         # (Required) Atlas event type.
#       enabled: true | false                      # (Optional) Enable this alert. Default: true.
#       notifications:
#         - type_name: string                      # (Required) Notification type.
#           roles: ["string"]                      # (Optional) Project roles to notify.
#           api_token: string                      # (Optional) Slack API token.
#           channel_name: string                   # (Optional) Slack channel name.
#           datadog_api_key: string                # (Optional) Datadog API key.
#           datadog_region: string                 # (Optional) Datadog region. Values: "US", "EU".
#           delay_min: number                      # (Optional) Delay in minutes before sending notification.
#           email_address: string                  # (Optional) Email address.
#           email_enabled: true | false            # (Optional) Send email to project owner.
#           interval_min: number                   # (Optional) Re-notification interval in minutes.
#           mobile_number: string                  # (Optional) Mobile number.
#           ops_genie_api_key: string              # (Optional) OpsGenie API key.
#           ops_genie_region: string               # (Optional) OpsGenie region. Values: "US", "EU".
#           service_key: string                    # (Optional) PagerDuty service key.
#           sms_enabled: true | false              # (Optional) Send SMS to project owner.
#           team_id: string                        # (Optional) Team ID to notify.
#           team_name: string                      # (Optional) Team name.
#           integration_id: string                 # (Optional) Third-party integration ID.
#           notifier_id: string                    # (Optional) Notifier ID.
#           username: string                       # (Optional) Atlas username for USER type.
#           victor_ops_api_key: string             # (Optional) VictorOps API key.
#           victor_ops_routing_key: string         # (Optional) VictorOps routing key.
#           webhook_secret: string                 # (Optional) Webhook HMAC secret.
#           webhook_url: string                    # (Optional) Webhook URL.
#           microsoft_teams_webhook_url: string    # (Optional) Microsoft Teams webhook URL.
#       matchers:
#         - field_name: string                     # (Optional) Field to match.
#           operator: string                       # (Optional) Comparison operator.
#           value: string                          # (Optional) Value to match against.
#       metric_threshold_config:
#         metric_name: string                      # (Optional) Atlas metric name.
#         operator: string                         # (Optional) Comparison operator.
#         threshold: number                        # (Optional) Numeric threshold value.
#         units: string                            # (Optional) Metric units.
#         mode: string                             # (Optional) Aggregation mode.
#       threshold_config:
#         operator: string                         # (Optional) Comparison operator.
#         threshold: number                        # (Optional) Numeric threshold value.
#         units: string                            # (Optional) Threshold units.
variable "settings" {
  description = "(Optional) Module settings object controlling project features: backup compliance, maintenance window, IP access list, and alert configurations"
  type        = any
  default     = {}
}

variable "generate_import" {
  # (Optional) When true, generates import blocks for existing Atlas resources. Default: false.
  description = "(Optional) Generate OpenTofu import blocks for existing Atlas resources"
  type        = bool
  default     = false
}

variable "encryption_provider" {
  # (Optional) Cloud provider for encryption at rest. Values: "AWS", "GCP", "AZURE". Default: "".
  # Must be a plain string — do NOT reference cloud resource attributes here to avoid dependency cycles.
  description = "(Optional) Cloud provider for encryption at rest. Values: AWS, GCP, AZURE. Passed separately from encryption_provider_config to avoid Terraform dependency cycles."
  type        = string
  default     = ""
}

## encryption_provider_config structure (all keys are optional unless noted):
#
# NOTE: Do NOT include the provider name here — use the separate encryption_provider variable instead.
# NOTE: Fields that Atlas supplies via cloud provider access setup (GCP service account email,
#       Azure app ID / SP ID / tenant ID) must NOT be repeated here — they are read directly
#       from mongodbatlas_cloud_provider_access_setup outputs inside access.tf.
#
# AWS-specific keys:
#   iam_assumed_role_arn: string                 # (Required for AWS) ARN of the IAM role that Atlas will assume.
#   customer_master_key_id: string               # (Required for AWS) ARN of the AWS KMS customer master key.
#   region: string                               # (Required for AWS) Atlas-format region (e.g., "US_EAST_1").
#
# GCP-specific keys (cloud provider access — no service account key required):
#   key_version_resource_id: string              # (Required for GCP) Full resource name of the GCP KMS crypto key version.
#
# AZURE-specific keys (cloud provider access — no client_id, secret, or tenant_id required):
#   azure_environment: string                    # (Optional) Azure cloud. Values: "AZURE", "AZURE_CHINA", "AZURE_GERMANY", "AZURE_US_GOVERNMENT". Default: "AZURE".
#   subscription_id: string                      # (Required for AZURE) Azure subscription ID.
#   resource_group_name: string                  # (Required for AZURE) Resource group containing the Key Vault.
#   key_vault_name: string                       # (Required for AZURE) Name of the Azure Key Vault.
#   key_identifier: string                       # (Required for AZURE) Versioned URI of the Key Vault key.
variable "encryption_provider_config" {
  description = "(Optional) Cloud-provider-specific encryption configuration passed from the cloud module. AWS: IAM role ARN + KMS key ARN + region. GCP: KMS key version resource ID. AZURE: subscription ID + resource group + key vault name + key identifier. Auth identifiers (GCP SA email, Azure app/SP/tenant) are sourced from mongodbatlas_cloud_provider_access_setup outputs."
  type        = any
  default     = {}
}
