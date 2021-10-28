variable "resource_group" {
  description = "Name of IBM-Cloud resource Group"
  type        = string
}
variable "region" {
  description = "IBM-Cloud Region"
  type        = string
}
variable "ibmcloud_api_key" {
  description = "IBM-Cloud API Key"
  type        = string
}
variable "resource_prefix" {
  description = "Common prefix to all resource names"
  type        = string
}
variable "managed_from" {
  description = "Location Data center"
  type        = string
}
variable "user_email" {
  description = "Email of Application User"
  type        = string
}
variable "user_name" {
  description = "Name of Application User"
  type        = string
}
variable "user_password" {
  description = "Password of Application User"
  type        = string
}
variable "location_profile" {
  description = "Profile information of location hosts"
  type        = string
  default     = "mx2-8x64"
}

variable "cluster_profile" {
  description = "Profile information of Cluster hosts"
  type        = string
  default     = "mx2-8x64"
}
