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

variable "settings" {
  description = "(optional) The backup compliance policy"
  type        = any
  default     = {}
}