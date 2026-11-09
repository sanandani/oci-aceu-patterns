variable "compartment_id" { type = string }
resource "oci_artifacts_container_repository" "service" {
  compartment_id = var.compartment_id
  display_name   = "aceu-trust-service"
  is_public      = false
}
output "repository_name" { value = oci_artifacts_container_repository.service.display_name }
