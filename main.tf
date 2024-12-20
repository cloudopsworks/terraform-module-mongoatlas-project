##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

data "mongodbatlas_organizations" "this" {
  count = var.organization_name != "" ? 1 : 0
  name  = var.organization_name
}

resource "mongodbatlas_project" "this" {
  name                                             = var.name != "" ? var.name : format("%s-%s", var.name_prefix, local.system_name_plain)
  org_id                                           = var.organization_id != "" ? var.organization_id : data.mongodbatlas_organizations.this[0].id
  with_default_alerts_settings                     = try(var.settings.default_alerts_settings, null)
  is_collect_database_specifics_statistics_enabled = try(var.settings.collect_database_specifics_statistics_enabled, null)
  is_data_explorer_enabled                         = try(var.settings.data_explorer_enabled, null)
  is_extended_storage_sizes_enabled                = try(var.settings.extended_storage_sizes_enabled, null)
  is_performance_advisor_enabled                   = try(var.settings.performance_advisor_enabled, null)
  is_schema_advisor_enabled                        = try(var.settings.schema_advisor_enabled, null)
  tags = { for k, v in local.all_tags :
    k => replace(v, "/[/$%&#]/", "+")
  }
}

resource "mongodbatlas_backup_compliance_policy" "this" {
  count                      = try(var.settings.backup_compliance.enabled, false) ? 1 : 0
  project_id                 = mongodbatlas_project.this.id
  authorized_email           = var.settings.backup_compliance.authorized_user.email
  authorized_user_first_name = var.settings.backup_compliance.authorized_user.first_name
  authorized_user_last_name  = var.settings.backup_compliance.authorized_user.last_name
  copy_protection_enabled    = try(var.settings.backup_compliance.copy_protection_enabled, false)
  pit_enabled                = try(var.settings.backup_compliance.pit_enabled, false)
  encryption_at_rest_enabled = try(var.settings.backup_compliance.encryption_at_rest_enabled, false)
  restore_window_days        = try(var.settings.backup_compliance.restore_window_days, 7)
  dynamic "policy_item_hourly" {
    for_each = length(try(var.settings.backup_compliance.hourly, {})) > 0 ? [var.settings.backup_compliance.hourly] : []
    content {
      frequency_interval = try(policy_item_hourly.value.interval, 1)
      retention_unit     = try(policy_item_hourly.value.retention_unit, "days")
      retention_value    = try(policy_item_hourly.value.retention_value, 1)
    }
  }
  dynamic "policy_item_daily" {
    for_each = length(try(var.settings.backup_compliance.daily, {})) > 0 ? [var.settings.backup_compliance.daily] : []
    content {
      frequency_interval = try(policy_item_daily.value.interval, 1)
      retention_unit     = try(policy_item_daily.value.retention_unit, "days")
      retention_value    = try(policy_item_daily.value.retention_value, 7)
    }
  }
  dynamic "policy_item_weekly" {
    for_each = length(try(var.settings.backup_compliance.weekly, {})) > 0 ? [var.settings.backup_compliance.weekly] : []
    content {
      frequency_interval = try(policy_item_weekly.value.interval, 1)
      retention_unit     = try(policy_item_weekly.value.retention_unit, "weeks")
      retention_value    = try(policy_item_weekly.value.retention_value, 4)
    }
  }
  dynamic "policy_item_monthly" {
    for_each = length(try(var.settings.backup_compliance.monthly, {})) > 0 ? [var.settings.backup_compliance.monthly] : []
    content {
      frequency_interval = try(policy_item_monthly.value.interval, 1)
      retention_unit     = try(policy_item_monthly.value.retention_unit, "months")
      retention_value    = try(policy_item_monthly.value.retention_value, 12)
    }
  }
  dynamic "policy_item_yearly" {
    for_each = length(try(var.settings.backup_compliance.yearly, {})) > 0 ? [var.settings.backup_compliance.yearly] : []
    content {
      frequency_interval = try(policy_item_yearly.value.interval, 1)
      retention_unit     = try(policy_item_yearly.value.retention_unit, "years")
      retention_value    = try(policy_item_yearly.value.retention_value, 2)
    }
  }
  dynamic "on_demand_policy_item" {
    for_each = length(try(var.settings.backup_compliance.on_demand, {})) > 0 ? [var.settings.backup_compliance.on_demand] : []
    content {
      frequency_interval = try(on_demand_policy_item.value.interval, 1)
      retention_unit     = try(on_demand_policy_item.value.retention_unit, "days")
      retention_value    = try(on_demand_policy_item.value.retention_value, 7)
    }
  }
}

resource "mongodbatlas_maintenance_window" "this" {
  count                   = try(var.settings.maintenance.enabled, false) ? 1 : 0
  project_id              = mongodbatlas_project.this.id
  day_of_week             = try(var.settings.maintenance.day_of_week, 1)
  hour_of_day             = try(var.settings.maintenance.hour_of_day, 0)
  start_asap              = try(var.settings.maintenance.start_asap, null)
  defer                   = try(var.settings.maintenance.defer, null)
  auto_defer              = try(var.settings.maintenance.auto_defer, null)
  auto_defer_once_enabled = try(var.settings.maintenance.auto_defer_once_enabled, null)
}

resource "mongodbatlas_project_ip_access_list" "this" {
  for_each           = try(var.settings.access_list, {})
  project_id         = mongodbatlas_project.this.id
  ip_address         = try(each.value.ip_address, null)
  comment            = try(each.value.comment, null)
  aws_security_group = try(each.value.security_group, null)
  cidr_block         = try(each.value.cidr_block, null)

}