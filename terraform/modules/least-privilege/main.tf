variable "tenancy_id" { type = string }
variable "compartment_name" { type = string }
variable "dynamic_group_name" { type = string }
resource "oci_identity_policy" "workload" {
  compartment_id = var.tenancy_id
  name           = "aceu-demo-workload-minimum"
  description    = "Narrow secret retrieval policy for tagged demo compute"
  statements     = ["Allow dynamic-group ${var.dynamic_group_name} to read secret-bundles in compartment ${var.compartment_name}"]
}
