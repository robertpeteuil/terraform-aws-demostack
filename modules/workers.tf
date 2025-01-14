resource "aws_iam_user" "workers" {
  count = "${var.workers}"

  name = "${var.namespace}-workers-${count.index}"
  path = "/${var.namespace}/"
}

resource "aws_iam_access_key" "workers" {
  count = "${var.workers}"
  user  = "${element(aws_iam_user.workers.*.name, count.index)}"
}

data "template_file" "workers_iam_policy" {
  count    = "${var.workers}"
  template = "${file("${path.module}/templates/policies/iam_policy.json.tpl")}"

  vars = {
    identity          = "${element(aws_iam_user.workers.*.name, count.index)}"
    region            = "${var.region}"
    owner_id          = "${aws_security_group.demostack.owner_id}"
    ami_id            = "${data.aws_ami.ubuntu.id}"
    subnet_id         = "${element(aws_subnet.demostack.*.id, count.index)}"
    security_group_id = "${aws_security_group.demostack.id}"
  }
}

# Create a limited policy for this user - this policy grants permission for the
# user to do incredibly limited things in the environment, such as launching a
# specific instance provided it has their authorization tag, deleting instances
# they have created, and describing instance data.
resource "aws_iam_user_policy" "workers" {
  count  = "${var.workers}"
  name   = "${var.namespace}-workers-${count.index}"
  user   = "${element(aws_iam_user.workers.*.name, count.index)}"
  policy = "${element(data.template_file.workers_iam_policy.*.rendered, count.index)}"
}

data "template_file" "workers" {
  count = "${var.workers}"

  template = "${join("\n", list(
    file("${path.module}/templates/shared/base.sh"),
    file("${path.module}/templates/shared/docker.sh"),
    file("${path.module}/templates/shared/run-proxy.sh"),
    
    file("${path.module}/templates/workers/user.sh"),
    file("${path.module}/templates/workers/consul.sh"),
    file("${path.module}/templates/workers/vault.sh"),
    file("${path.module}/templates/workers/postgres.sh"),
    file("${path.module}/templates/workers/terraform.sh"),
    file("${path.module}/templates/workers/tools.sh"),
    file("${path.module}/templates/workers/nomad.sh"),
    file("${path.module}/templates/workers/connectdemo.sh"),
    ))}"

  vars = {
    namespace  = "${var.namespace}"
    node_name  = "${element(aws_iam_user.workers.*.name, count.index)}"
    enterprise = "${var.enterprise}"

    #me_ca     = "${tls_self_signed_cert.root.cert_pem}"
    me_ca   = "${var.ca_cert_pem}"
    me_cert = "${element(tls_locally_signed_cert.workers.*.cert_pem, count.index)}"
    me_key  = "${element(tls_private_key.workers.*.private_key_pem, count.index)}"

    # User
    demo_username = "${var.demo_username}"
    demo_password = "${var.demo_password}"
    identity      = "${element(aws_iam_user.workers.*.name, count.index)}"

    # Consul
    consul_url            = "${var.consul_url}"
    consul_ent_url        = "${var.consul_ent_url}"
    consul_gossip_key     = "${var.consul_gossip_key}"
    consul_join_tag_key   = "ConsulJoin"
    consul_join_tag_value = "${var.consul_join_tag_value}"

    # Terraform
    terraform_url     = "${var.terraform_url}"
    region            = "${var.region}"
    ami_id            = "${data.aws_ami.ubuntu.id}"
    subnet_id         = "${element(aws_subnet.demostack.*.id, count.index)}"
    security_group_id = "${aws_security_group.demostack.id}"
    access_key        = "${element(aws_iam_access_key.workers.*.id, count.index)}"
    secret_key        = "${element(aws_iam_access_key.workers.*.secret, count.index)}"

    # Tools
    consul_template_url = "${var.consul_template_url}"
    envconsul_url       = "${var.envconsul_url}"
    packer_url          = "${var.packer_url}"
    sentinel_url        = "${var.sentinel_url}"

    # Nomad
    nomad_url      = "${var.nomad_url}"
    run_nomad_jobs = "${var.run_nomad_jobs}"

    # Vault
    vault_url        = "${var.vault_url}"
    vault_ent_url    = "${var.vault_ent_url}"
    vault_root_token = "${random_id.vault-root-token.hex}"
    vault_servers    = "${var.workers}"
  }
}

# Gzip cloud-init config
data "template_cloudinit_config" "workers" {
  count = "${var.workers}"

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${element(data.template_file.workers.*.rendered, count.index)}"
  }
}

# IAM
resource "aws_iam_role" "workers" {
  count              = "${var.workers}"
  name               = "${var.namespace}-workers-${count.index}"
  assume_role_policy = "${file("${path.module}/templates/policies/assume-role.json")}"
}

resource "aws_iam_policy" "workers" {
  count       = "${var.workers}"
  name        = "${var.namespace}-workers-${count.index}"
  description = "Allows user ${element(aws_iam_user.workers.*.name, count.index)} to use their workers server."
  policy      = "${element(data.template_file.workers_iam_policy.*.rendered, count.index)}"
}

resource "aws_iam_policy_attachment" "workers" {
  count      = "${var.workers}"
  name       = "${var.namespace}-workers-${count.index}"
  roles      = ["${element(aws_iam_role.workers.*.name, count.index)}"]
  policy_arn = "${element(aws_iam_policy.workers.*.arn, count.index)}"
}

resource "aws_iam_instance_profile" "workers" {
  count = "${var.workers}"
  name  = "${var.namespace}-workers-${count.index}"
  role  = "${element(aws_iam_role.workers.*.name, count.index)}"
}

resource "aws_instance" "workers" {
  count = "${var.workers}"

  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type_worker}"
  key_name      = "${aws_key_pair.demostack.id}"

  subnet_id              = "${element(aws_subnet.demostack.*.id, count.index)}"
  iam_instance_profile   = "${element(aws_iam_instance_profile.workers.*.name, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demostack.id}"]

  root_block_device{
    volume_size           = "50"
    delete_on_termination = "true"
  }

   ebs_block_device  {
    device_name           = "/dev/xvdd"
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
}

  tags = {
    Name       = "${var.namespace}-workers-${count.index}"
    owner      = "${var.owner}"
    created-by = "${var.created-by}"
  }

  user_data = "${element(data.template_cloudinit_config.workers.*.rendered, count.index)}"
}
