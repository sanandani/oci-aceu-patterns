variable "tenancy_ocid" {
  type    = string
  default = "ocid1.tenancy.oc1..placeholder"
}
variable "user_ocid" {
  type    = string
  default = "ocid1.user.oc1..placeholder"
}
variable "fingerprint" {
  type    = string
  default = "00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00"
}
variable "private_key_path" {
  type    = string
  default = "~/.oci/placeholder.pem"
}
variable "region" {
  type    = string
  default = "us-placeholder-1"
}
variable "compartment_name" {
  type    = string
  default = "aceu-patterns-demo"
}
variable "parent_compartment_id" {
  type    = string
  default = "ocid1.tenancy.oc1..placeholder"
}
variable "subnet_id" {
  type    = string
  default = "ocid1.subnet.oc1..placeholder"
}
variable "ampere_image_id" {
  type    = string
  default = "ocid1.image.oc1..placeholder"
}
variable "ocir_namespace" {
  type    = string
  default = "NAMESPACE_PLACEHOLDER"
}
variable "vault_secret_base64" {
  type      = string
  sensitive = true
  default   = "REPLACE_AT_APPLY"
}
variable "ocir_region" {
  type    = string
  default = "phx"
}
variable "ocir_username" {
  type    = string
  default = "TENANCY_NAMESPACE/oracleidentitycloudservice/USERNAME_PLACEHOLDER"
}
