variable "region" {
  description = "The region to create resources."
  default     = "us-west-2"
}

variable "namespace" {
  description = <<EOH
The namespace to create the virtual training lab. This should describe the
training and must be unique to all current trainings. IAM users, workstations,
and resources will be scoped under this namespace.
EOH


  default = "primaryconnectdemo"
}

variable "primary_region" {
  description = "The region to create resources."
  default = "us-west-2"
}

variable "secondary_region" {
  description = "The region to create resources."
  default = "us-east-1"
}

variable "servers" {
  description = "The number of data servers (consul, nomad, etc)."
  default = "3"
}

variable "workers" {
  description = "The number of nomad worker vms to create."
  default = "3"
}

variable "consul_url" {
  description = "The url to download Consul."
  default = "https://releases.hashicorp.com/consul/1.5.2/consul_1.5.2_linux_amd64.zip"
}

variable "consul_ent_url" {
  description = "The url to download Consul."
  default = "https://releases.hashicorp.com/consul/1.5.2/consul_1.5.2_linux_amd64.zip"
}

variable "packer_url" {
  description = "The url to download Packer."
  default = "https://releases.hashicorp.com/packer/1.4.2/packer_1.4.2_linux_amd64.zip"
}

variable "sentinel_url" {
  description = "The url to download Sentinel simulator."
  default = "https://releases.hashicorp.com/sentinel/0.10.3/sentinel_0.10.3_linux_amd64.zip"
}

variable "consul_template_url" {
  description = "The url to download Consul Template."
  default = "https://releases.hashicorp.com/consul-template/0.20.0/consul-template_0.20.0_linux_amd64.zip"
}

variable "envconsul_url" {
  description = "The url to download Envconsul."
  default = "https://releases.hashicorp.com/envconsul/0.8.0/envconsul_0.8.0_linux_amd64.zip"
}

variable "fabio_url" {
  description = "The url download fabio."
  default = "https://github.com/fabiolb/fabio/releases/download/v1.5.10/fabio-1.5.10-go1.11.1-linux_amd64"
  # default = "https://github.com/fabiolb/fabio/releases/download/v1.5.7/fabio-1.5.7-go1.9.2-linux_amd64"
}

variable "hashiui_url" {
  description = "The url to download hashi-ui."
  default = "https://github.com/jippi/hashi-ui/releases/download/v1.1.0/hashi-ui-linux-amd64"
}

variable "nomad_url" {
  description = "The url to download nomad."
  default = "https://releases.hashicorp.com/nomad/0.9.3/nomad_0.9.3_linux_amd64.zip"
}

variable "nomad_ent_url" {
  description = "The url to download nomad."
  default = "https://releases.hashicorp.com/nomad/0.9.3/nomad_0.9.3_linux_amd64.zip"
}

variable "terraform_url" {
  description = "The url to download terraform."
  default = "https://releases.hashicorp.com/terraform/0.12.5/terraform_0.12.5_linux_amd64.zip"
}

variable "vault_url" {
  description = "The url to download vault."
  default = "https://releases.hashicorp.com/vault/1.1.3/vault_1.1.3_linux_amd64.zip"
}

variable "vault_ent_url" {
  description = "The url to download vault."
  default = "https://s3-us-west-2.amazonaws.com/hc-enterprise-binaries/vault/ent/1.1.3/vault-enterprise_1.1.3%2Bent_linux_amd64.zip"
}

variable "primary_namespace" {
  description = <<EOH
The namespace to create the virtual training lab. This should describe the
training and must be unique to all current trainings. IAM users, workstations,
and resources will be scoped under this namespace.

It is best if you add this to your .tfvars file so you do not need to type
it manually with each run
EOH


default = "primaryconnectdemo"
}

variable "secondary_namespace" {
description = <<EOH
The namespace to create the virtual training lab. This should describe the
training and must be unique to all current trainings. IAM users, workstations,
and resources will be scoped under this namespace.

It is best if you add this to your .tfvars file so you do not need to type
it manually with each run
EOH


default = "secondaryconnectdemo"
}

variable "owner" {
description = "IAM user responsible for lifecycle of cloud resources used for training"
}

variable "created-by" {
description = "Tag used to identify resources created programmatically by Terraform"
default = "Terraform"
}

variable "sleep-at-night" {
description = "Tag used by reaper to identify resources that can be shutdown at night"
default = true
}

variable "TTL" {
description = "Hours after which resource expires, used by reaper. Do not use any unit. -1 is infinite."
default = "240"
}

variable "vpc_cidr_block" {
description = "The top-level CIDR block for the VPC."
default = "10.1.0.0/16"
}

variable "cidr_blocks" {
description = "The CIDR blocks to create the workstations in."
default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "demo_username" {
description = "The username to attach to the user demo login as."
default = "demo"
}

variable "demo_password" {
description = "The password to attach to the user demo login as."
default = "demo"
}

variable "public_key" {
description = "The contents of the SSH public key to use for connecting to the cluster."
}

variable "enterprise" {
description = "do you want to use the enterprise version of the binaries"
default = false
}

variable "vaultlicense" {
description = "Enterprise License for Vault"
default = ""
}

variable "consullicense" {
description = "Enterprise License for Consul"
default = ""
}

/*
variable "awsaccesskey" {
  description = "The AWS access key vault will use for auto unseal"
}

variable "awssecretkey" {
  description = "The AWS secret key vault will use for auto unseal"
}
*/
variable "instance_type_server" {
description = "The type(size) of data servers (consul, nomad, etc)."
default = "r5.large"
}

variable "instance_type_worker" {
description = "The type(size) of data servers (consul, nomad, etc)."
default = "t2.medium"
}

variable "ca_key_algorithm" {
default = ""
}

variable "ca_private_key_pem" {
default = ""
}

variable "ca_cert_pem" {
default = ""
}

variable "consul_gossip_key" {
default = ""
}

variable "consul_master_token" {
default = ""
}

variable "consul_join_tag_value" {
default = ""
}

variable "nomad_gossip_key" {
default = ""
}

variable "run_nomad_jobs" {
default = 1
}

