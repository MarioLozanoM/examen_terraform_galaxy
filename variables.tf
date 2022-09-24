variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "admin_username" {
  description = "The username of the local administrator on the virtual machine."
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "The password of the local administrator on the virtual machine."
  type        = string
  sensitive   = true
}
