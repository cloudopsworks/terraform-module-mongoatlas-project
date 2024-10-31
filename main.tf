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
  name   = var.name != "" ? var.name : format("%s-%s", var.name_prefix, local.system_name)
  org_id = var.organization_id != "" ? var.organization_id : data.mongodbatlas_organizations.this[0].id
}