##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "project_name" {
  value = mongodbatlas_project.this.name
}

output "project_id" {
  value = mongodbatlas_project.this.id
}

output "project_creation_timestamp" {
  value = mongodbatlas_project.this.created
}

