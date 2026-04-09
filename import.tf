##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  format_alerts        = data.mongodbatlas_alert_configurations.import.results
  excluded_event_types = try(var.settings.excluded_alert_event_types, [])
  import_statements = compact([
    for i, alert in local.format_alerts :
    "import 'mongodbatlas_alert_configuration.alert[\"${alert.event_type}-${try(alert.metric_threshold_config[0].metric_name, "")}${try(alert.metric_threshold_config[0].operator, alert.threshold_config[0].operator, "")}${try(alert.metric_threshold_config[0].threshold, alert.threshold_config[0].threshold, "")}\"]' '${alert.project_id}-${alert.alert_configuration_id}'"
    if !contains(local.excluded_event_types, alert.event_type)
  ])
  alert_yaml = {
    alerts = [
      for i, alert in local.format_alerts : {
        event_type = alert.event_type
        enabled    = alert.enabled
        notifications = [
          for n in alert.notification : {
            type_name                   = n.type_name
            roles                       = try(n.roles, null)
            api_token                   = try(n.api_token, null)
            channel_name                = try(n.channel_name, null)
            datadog_api_key             = try(n.datadog_api_key, null)
            datadog_region              = try(n.datadog_region, null)
            delay_min                   = try(n.delay_min, null)
            email_address               = try(n.email_address, null)
            email_enabled               = try(n.email_enabled, null)
            interval_min                = try(n.interval_min, null)
            mobile_number               = try(n.mobile_number, null)
            ops_genie_api_key           = try(n.ops_genie_api_key, null)
            ops_genie_region            = try(n.ops_genie_region, null)
            service_key                 = try(n.service_key, null)
            sms_enabled                 = try(n.sms_enabled, null)
            team_id                     = try(n.team_id, null)
            team_name                   = try(n.team_name, null)
            integration_id              = try(n.integration_id, null)
            notifier_id                 = try(n.notifier_id, null)
            username                    = try(n.username, null)
            victor_ops_api_key          = try(n.victor_ops_api_key, null)
            victor_ops_routing_key      = try(n.victor_ops_routing_key, null)
            webhook_url                 = try(n.webhook_url, null)
            webhook_secret              = try(n.webhook_secret, null)
            microsoft_teams_webhook_url = try(n.microsoft_teams_webhook_url, null)
          }
        ]
        matchers = [
          for m in alert.matcher : {
            field_name = m.field_name
            operator   = m.operator
            value      = m.value
          }
        ]
        metric_threshold_config = length(try(alert.metric_threshold_config, [])) > 0 ? {
          metric_name = alert.metric_threshold_config[0].metric_name
          operator    = alert.metric_threshold_config[0].operator
          threshold   = alert.metric_threshold_config[0].threshold
          units       = alert.metric_threshold_config[0].units
          mode        = alert.metric_threshold_config[0].mode
        } : null
        threshold_config = length(try(alert.threshold_config, [])) > 0 ? {
          operator  = alert.threshold_config[0].operator
          threshold = alert.threshold_config[0].threshold
          units     = alert.threshold_config[0].units
        } : null
      } if !contains(local.excluded_event_types, alert.event_type)
    ]
  }
}

data "mongodbatlas_alert_configurations" "import" {
  project_id = mongodbatlas_project.this.id
}

output "imported_alert_statement" {
  value = var.generate_import ? join("\n", local.import_statements) : null
}

output "imported_alert_json" {
  value = var.generate_import ? nonsensitive(jsonencode(local.alert_yaml)) : null
}
