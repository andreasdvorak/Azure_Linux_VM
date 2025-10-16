variable "admin_username" {
    description = "admin username for Ubuntu"
    type = string
}

variable "admin_password" {
    description = "admin password for Ubuntu"
    type = string
    sensitive = true
}

variable "client_id" {
    description = "client id for azure"
    type = string
}

variable "client_secret" {
    description = "client secret for azure"
    type = string
}

variable "number_of_subnets" {
    default = 1
    description = "number of subnets"
    type = number
    validation {
      condition = var.number_of_subnets < 5
      error_message = "The number of subnets must be less than 5"
    }
}

variable "subscription_id" {
    description = "subscription id for azure"
    type = string
}

variable "tenant_id" {
    description = "tenant id for azure"
    type = string
}

variable "os_offer" {
    description = "os to offer"
    type = string
}

variable "os_sku" {
    description = "os sku"
    type = string
}