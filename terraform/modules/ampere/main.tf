variable "compartment_id" { type = string }
variable "subnet_id" { type = string }
variable "image_id" { type = string }
variable "vault_secret_id" { type = string }
variable "ocir_namespace" { type = string }
variable "ocir_region" { type = string }
variable "ocir_username" { type = string }
variable "defined_tag" { type = string }
locals {
  cloud_init = <<-CLOUD
    #cloud-config
    packages: [docker.io, python3-oci-cli]
    runcmd:
      - [systemctl, enable, --now, docker]
      - [bash, -lc, "oci secrets secret-bundle get --secret-id ${var.vault_secret_id} --auth instance_principal --query 'data.\\\"secret-bundle-content\\\".content' --raw-output | base64 -d | docker login ${var.ocir_region}.ocir.io -u '${var.ocir_username}' --password-stdin"]
      - [docker, run, -d, --restart, unless-stopped, -p, "8080:8080", "${var.ocir_region}.ocir.io/${var.ocir_namespace}/aceu-trust-service:latest"]
  CLOUD
}
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}
resource "oci_core_instance" "demo" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "aceu-demo-a1"
  shape               = "VM.Standard.A1.Flex"
  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }
  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
  }
  source_details {
    source_type = "image"
    source_id   = var.image_id
  }
  defined_tags = { (var.defined_tag) = "true" }
  metadata     = { user_data = base64encode(local.cloud_init) }
}
