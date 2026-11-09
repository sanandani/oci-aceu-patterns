variable "compartment_id" { type = string }
variable "secret_base64" {
  type      = string
  sensitive = true
}
resource "oci_kms_vault" "demo" {
  compartment_id = var.compartment_id
  display_name   = "aceu-demo-vault"
  vault_type     = "DEFAULT"
}
resource "oci_kms_key" "demo" {
  compartment_id      = var.compartment_id
  display_name        = "aceu-demo-key"
  management_endpoint = oci_kms_vault.demo.management_endpoint
  key_shape {
    algorithm = "AES"
    length    = 32
  }
}
resource "oci_vault_secret" "demo" {
  compartment_id = var.compartment_id
  secret_name    = "aceu-demo-ocir-token"
  vault_id       = oci_kms_vault.demo.id
  key_id         = oci_kms_key.demo.id
  description    = "Placeholder secret. Replace with a synthetic short-lived OCIR credential before apply."
  secret_content {
    content      = var.secret_base64
    content_type = "BASE64"
  }
}
output "secret_id" { value = oci_vault_secret.demo.id }
