variable "tfResourcePrefix" {
  type    = string
  default = "tf-"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "workspace" {
  type        = string
  description = "Name of the Azure Virtual Desktop workspace"
  default     = "AVD TF Workspace"
}

variable "hostpool" {
  type        = string
  description = "Name of the Azure Virtual Desktop host pool"
  default     = "AVD-TF-HP"
}