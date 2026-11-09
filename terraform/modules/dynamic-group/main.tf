variable "compartment_id" { type = string }
variable "tenancy_id" { type = string }
resource "oci_identity_tag_namespace" "demo" {
  compartment_id = var.compartment_id
  name           = "aceu-demo"
  description    = "Tag namespace for the synthetic ACE-U workload"
}
resource "oci_identity_tag" "managed" {
  tag_namespace_id = oci_identity_tag_namespace.demo.id
  name             = "managed"
  description      = "Exact workload membership marker"
}
resource "oci_identity_dynamic_group" "service" {
  compartment_id = var.tenancy_id
  name           = "aceu-demo-instances"
  description    = "ACE-U demo instances limited by a defined tag"
  matching_rule  = "Any {tag.aceu-demo.managed.value = 'true'}"
}
output "name" { value = oci_identity_dynamic_group.service.name }
output "defined_tag" { value = "${oci_identity_tag_namespace.demo.name}.${oci_identity_tag.managed.name}" }
output "tag_namespace" { value = oci_identity_tag_namespace.demo.name }
