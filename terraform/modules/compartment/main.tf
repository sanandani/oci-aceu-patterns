variable "parent_id" { type = string }
variable "name" { type = string }
resource "oci_identity_compartment" "demo" {
  compartment_id = var.parent_id
  name           = var.name
  description    = "Synthetic ACE-U portfolio demo"
  enable_delete  = true
}
output "id" { value = oci_identity_compartment.demo.id }
