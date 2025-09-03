variable "resource_group_name" { type = string  default = "rg-tpot-honeypot" }
variable "location"            { type = string  default = "eastus" }
variable "vm_name"             { type = string  default = "vm-tpot-honeypot" }
variable "vm_size"             { type = string  default = "Standard_D4s_v3" }
variable "admin_username"      { type = string  default = "tpotadmin" }
variable "ssh_public_key"      { type = string }
