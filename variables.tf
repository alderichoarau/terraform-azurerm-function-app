variable "name" {
  description = "Name of the Linux Function App"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,58}[a-z0-9]$", var.name))
    error_message = "name must be lowercase, letters, digits and hyphens only (2-60 chars)."
  }
}

variable "storage_account_name" {
  description = "Name of the storage account dedicated to the Function App (lowercase letters and digits only, 3-24 chars)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3-24 chars, lowercase letters and digits only."
  }
}

variable "resource_group_name" {
  description = "Name of the Resource Group to deploy into"
  type        = string
}

variable "location" {
  description = "Azure region for the Function App and its dedicated storage account"
  type        = string
}

variable "service_plan_id" {
  description = "ID of the (shared or dedicated) App Service Plan the Function App runs on"
  type        = string
}

variable "python_version" {
  description = "Python runtime version for the Function App stack"
  type        = string
  default     = "3.11"
}

variable "app_settings" {
  description = "Application settings merged with the module's defaults"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags applied to all resources in this module"
  type        = map(string)
  default     = {}
}
