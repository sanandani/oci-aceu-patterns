module "compartment" {
  source    = "./modules/compartment"
  parent_id = var.parent_compartment_id
  name      = var.compartment_name
}
module "dynamic_group" {
  source         = "./modules/dynamic-group"
  compartment_id = module.compartment.id
  tenancy_id     = var.parent_compartment_id
}
module "least_privilege" {
  source             = "./modules/least-privilege"
  tenancy_id         = var.parent_compartment_id
  compartment_name   = var.compartment_name
  dynamic_group_name = module.dynamic_group.name
}
module "vault" {
  source         = "./modules/vault"
  compartment_id = module.compartment.id
  secret_base64  = var.vault_secret_base64
}
module "ocir" {
  source         = "./modules/ocir"
  compartment_id = module.compartment.id
}
module "ampere" {
  source          = "./modules/ampere"
  compartment_id  = module.compartment.id
  subnet_id       = var.subnet_id
  image_id        = var.ampere_image_id
  vault_secret_id = module.vault.secret_id
  ocir_namespace  = var.ocir_namespace
  ocir_region     = var.ocir_region
  ocir_username   = var.ocir_username
  defined_tag     = module.dynamic_group.defined_tag
  depends_on      = [module.dynamic_group]
}
output "compartment_id" { value = module.compartment.id }
output "private_ocir_repository" { value = module.ocir.repository_name }
