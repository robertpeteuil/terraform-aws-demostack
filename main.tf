//--------------------------MULTICLOUD-IAC------------------------------------------
# Using a single workspace:
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "multicloud-iac"

    workspaces {
      name = "AWS-demostack"
    }
  }
}

// Workspace Data
data "terraform_remote_state" "multicloud_iac_tls_root_certificate" {
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "multicloud-iac"
    workspaces = {
      name = "tls-root-certificate"
    }
  }
}

//--------------------------------------------------------------------

provider "aws" {
  version = ">= 1.20.0"
  region  = var.primary_region
}

module "primarycluster" {
  source = "./modules"

  owner                = var.owner
  region               = var.primary_region
  namespace            = var.primary_namespace
  public_key           = var.public_key
  demo_username        = var.demo_username
  demo_password        = var.demo_password
  servers              = var.servers
  workers              = var.workers
  vaultlicense         = var.vaultlicense
  consullicense        = var.consullicense
  enterprise           = var.enterprise
  consul_url           = var.consul_url
  consul_ent_url       = var.consul_ent_url
  packer_url           = var.packer_url
  sentinel_url         = var.sentinel_url
  consul_template_url  = var.consul_template_url
  envconsul_url        = var.envconsul_url
  fabio_url            = var.fabio_url
  hashiui_url          = var.hashiui_url
  nomad_url            = var.nomad_url
  nomad_ent_url        = var.nomad_ent_url
  terraform_url        = var.terraform_url
  vault_url            = var.vault_url
  vault_ent_url        = var.vault_ent_url
  created-by           = var.created-by
  sleep-at-night       = var.sleep-at-night
  TTL                  = var.TTL
  vpc_cidr_block       = var.vpc_cidr_block
  cidr_blocks          = var.cidr_blocks
  instance_type_server = var.instance_type_server
  instance_type_worker = var.instance_type_worker
  run_nomad_jobs       = var.run_nomad_jobs

  //  ca_key_algorithm   = var.ca_key_algorithm
  //  ca_private_key_pem = var.ca_private_key_pem
  //  ca_cert_pem        = var.ca_cert_pem

  # MULTICLOUD-IAC
  ca_key_algorithm      = data.terraform_remote_state.multicloud_iac_tls_root_certificate.outputs.ca_key_algorithm
  ca_private_key_pem    = data.terraform_remote_state.multicloud_iac_tls_root_certificate.outputs.ca_private_key_pem
  ca_cert_pem           = data.terraform_remote_state.multicloud_iac_tls_root_certificate.outputs.ca_cert_pem
  consul_join_tag_value = "${var.namespace}-${data.terraform_remote_state.multicloud_iac_tls_root_certificate.outputs.consul_join_tag_value}"
  consul_gossip_key     = data.terraform_remote_state.multicloud_iac_tls_root_certificate.outputs.consul_gossip_key
  consul_master_token   = data.terraform_remote_state.multicloud_iac_tls_root_certificate.outputs.consul_master_token
  nomad_gossip_key      = data.terraform_remote_state.multicloud_iac_tls_root_certificate.outputs.nomad_gossip_key

}

/*
module "secondarycluster" {
  source              = "./modules"
  owner               = var.owner
  region              = var.secondary_region
  namespace           = var.secondary_namespace
  public_key          = var.public_key
  demo_username       = var.demo_username
  demo_password       = var.demo_password
  servers             = var.servers
  workers             = var.workers
  vaultlicense        = var.vaultlicense
  consullicense       = var.consullicense
  enterprise          = var.enterprise
  consul_url          = var.consul_url
  consul_ent_url      = var.consul_ent_url
  packer_url          = var.packer_url
  sentinel_url        = var.sentinel_url
  consul_template_url = var.consul_template_url
  envconsul_url       = var.envconsul_url
  fabio_url           = var.fabio_url
  hashiui_url         = var.hashiui_url
  nomad_url           = var.nomad_url
  nomad_ent_url       = var.nomad_ent_url
  terraform_url       = var.terraform_url
  vault_url           = var.vault_url
  vault_ent_url       = var.vault_ent_url
  created-by          = var.created-by
  sleep-at-night      = var.sleep-at-night
  TTL                 = var.TTL
  vpc_cidr_block      = var.vpc_cidr_block
  cidr_blocks         = var.cidr_blocks
  instance_type_server= var.instance_type_server
  instance_type_worker= var.instance_type_worker

  //  ca_key_algorithm   = var.ca_key_algorithm
  //  ca_private_key_pem = var.ca_private_key_pem
  //  ca_cert_pem        = var.ca_cert_pem

  ca_key_algorithm = data.terraform_remote_state.multicloud_iac_tls_root_certificate.ca_key_algorithm
  ca_private_key_pem = data.terraform_remote_state.multicloud_iac_tls_root_certificate.ca_private_key_pem
  ca_cert_pem        = data.terraform_remote_state.multicloud_iac_tls_root_certificate.ca_cert_pem
  consul_join_tag_value = var.namespace}-${data.terraform_remote_state.multicloud_iac_tls_root_certificate.consul_join_tag_value
  consul_gossip_key = data.terraform_remote_state.multicloud_iac_tls_root_certificate.consul_gossip_key
  consul_master_token = data.terraform_remote_state.multicloud_iac_tls_root_certificate.consul_master_token
  nomad_gossip_key = data.terraform_remote_state.multicloud_iac_tls_root_certificate.nomad_gossip_key
}
*/
