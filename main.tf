##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  atlas_name = var.name != "" ? var.name : format("%s-%s", var.name_prefix, local.system_name_plain)
}

resource "mongodbatlas_project" "this" {
  name                                             = local.atlas_name
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

resource "mongodbatlas_alert_configuration" "alert" {
  for_each = {
    for idx, alert in try(var.settings.alerts, []) : "${alert.event_type}-${try(alert.metric_threshold_config.metric_name, "")}${try(alert.metric_threshold_config.operator, alert.threshold_config.operator, "")}${try(alert.metric_threshold_config.threshold, alert.threshold_config.threshold, "")}" => alert
    if !contains(try(var.settings.excluded_alert_event_types, []), alert.event_type)
  }
  project_id = mongodbatlas_project.this.id
  event_type = each.value.event_type
  enabled    = try(each.value.enabled, true)
  dynamic "notification" {
    for_each = try(each.value.notifications, [])
    content {
      type_name                   = try(notification.value.type_name, null)
      roles                       = try(notification.value.roles, null)
      api_token                   = try(notification.value.api_token, null)
      channel_name                = try(notification.value.channel_name, null)
      datadog_api_key             = try(notification.value.datadog_api_key, null)
      datadog_region              = try(notification.value.datadog_region, null)
      delay_min                   = try(notification.value.delay_min, null)
      email_address               = try(notification.value.email_address, null)
      email_enabled               = try(notification.value.email_enabled, null)
      interval_min                = try(notification.value.interval_min, null)
      mobile_number               = try(notification.value.mobile_number, null)
      ops_genie_api_key           = try(notification.value.ops_genie_api_key, null)
      ops_genie_region            = try(notification.value.ops_genie_region, null)
      service_key                 = try(notification.value.service_key, null)
      sms_enabled                 = try(notification.value.sms_enabled, null)
      team_id                     = try(notification.value.team_id, null)
      team_name                   = try(notification.value.team_name, null)
      integration_id              = try(notification.value.integration_id, null)
      notifier_id                 = try(notification.value.notifier_id, null)
      username                    = try(notification.value.username, null)
      victor_ops_api_key          = try(notification.value.victor_ops_api_key, null)
      victor_ops_routing_key      = try(notification.value.victor_ops_routing_key, null)
      webhook_url                 = try(notification.value.webhook_url, null)
      webhook_secret              = try(notification.value.webhook_secret, null)
      microsoft_teams_webhook_url = try(notification.value.microsoft_teams_webhook_url, null)
    }
  }
  dynamic "matcher" {
    for_each = try(each.value.matchers, [])
    content {
      field_name = try(matcher.value.field_name, null)
      operator   = try(matcher.value.operator, null)
      value      = try(matcher.value.value, null)
    }
  }
  dynamic "metric_threshold_config" {
    for_each = length(try(each.value.metric_threshold_config, {})) > 0 ? [1] : []
    content {
      metric_name = try(each.value.metric_threshold_config.metric_name, null)
      operator    = try(each.value.metric_threshold_config.operator, null)
      threshold   = try(each.value.metric_threshold_config.threshold, null)
      units       = try(each.value.metric_threshold_config.units, null)
      mode        = try(each.value.metric_threshold_config.mode, null)
    }
  }
  dynamic "threshold_config" {
    for_each = length(try(each.value.threshold_config, {})) > 0 ? [1] : []
    content {
      operator  = try(each.value.threshold_config.operator, null)
      threshold = try(each.value.threshold_config.threshold, null)
      units     = try(each.value.threshold_config.units, null)
    }
  }
}
