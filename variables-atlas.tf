##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "name_prefix" {
  description = "Prefix for the name of the resources"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name of the resource"
  type        = string
  default     = ""
}

variable "organization_name" {
  description = "(optional) The name of the organization where the project will be created"
  type        = string
  default     = ""
}

variable "organization_id" {
  description = "(optional) The ID of the organization where the project will be created"
  type        = string
  default     = ""
}

## Settings YAML format:
# settings:
#   default_alerts_settings: true | false
#   collect_database_specifics_statistics_enabled: true | false
#   data_explorer_enabled: true | false
#   extended_storage_sizes_enabled: true | false
#   performance_advisor_enabled: true | false
#   schema_advisor_enabled: true | false
#   backup_compliance:
#     enabled: true | false  (default: false)
#     authorized_user:
#       email: string
#       first_name: string
#       last_name: string
#     copy_protection_enabled: true | false (default: false)
#     pit_enabled: true | false (default: false)
#     encryption_at_rest_enabled: true | false (default: false)
#     restore_window_days: number (default: 7)
#     hourly:
#       interval: number (default: 1)
#       retention_unit: string (default: "days")
#       retention_value: number (default: 1)
#     daily:
#       interval: number (default: 1)
#       retention_unit: string (default: "days")
#       retention_value: number (default: 7)
#     weekly:
#       interval: number (default: 1)
#       retention_unit: string (default: "weeks")
#       retention_value: number (default: 4)
#     monthly:
#       interval: number (default: 1)
#       retention_unit: string (default: "months")
#       retention_value: number (default: 12)
#     yearly:
#       interval: number (default: 1)
#       retention_unit: string (default: "years")
#       retention_value: number (default: 2)
#     on_demand:
#       interval: number (default: 1)
#       retention_unit: string (default: "days")
#       retention_value: number (default: 7)
#  maintenance:
#    enabled: true | false (default: false)
#    day_of_week: string (default: 1 "Sunday")
#    hour_of_day: number (default: 0)
#    start_asap: true | false (default: null)
#    defer: true | false (default: null)
#    auto_defer: true | false (default: null)
#    auto_defer_once_enabled: true | false (default: null)
#  access_list:
#   <id>:
#     comment: string (optional, item comment)
#     ip_address: string (optional, conflicts with aws_security_group & cidr_block)
#     aws_security_group: string (optional, conflicts with ip_address & cidr_block)
#     cidr_block: string (optional, conflicts with ip_address & aws_security_group)
# encryption_at_rest:
#   enabled: true | false (default: false)
#   deletion_window_in_days: number (default: 7)
#   enable_key_rotation: true | false (default: true)
#   rotation_period_in_days: number (default: 90)
#   multi_region: true | false (default: false)
variable "settings" {
  description = "(optional) The backup compliance policy"
  type        = any
  default     = {}
}