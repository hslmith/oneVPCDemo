//Single Zone, Single VPC, Variable Server Count


////////////////
//Create VPC
///////////////

data "ibm_resource_group" "resource" {
  name = "${var.resource_group}"
}

resource "ibm_is_vpc" "vpc1" {
  name = var.vpc-name
  address_prefix_management = "manual"
  # resource_group = "data.ibm_resource_group.resource.id"
}

////////////////
//Network Config
///////////////

// Public Gateway()s


resource "ibm_is_public_gateway" "pubgw-zone1" {
  name = "${var.vpc-name}-${var.zone1}-pubgw"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone1}"
}

//--- address prexix for VPC

resource "ibm_is_vpc_address_prefix" "prefix_z1" {
  name = "vpc-zone1-cidr"
  zone = "${var.zone1}"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  cidr = "${var.az1-prefix}"
}

//--- subnets

resource "ibm_is_subnet" "websubnet1" {
  name            = "web-subnet-zone1"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone1}"
  network_acl     = "${ibm_is_network_acl.isBasicACL.id}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-zone1.id}"
  ipv4_cidr_block = "${var.subnet-zone1}"
  depends_on      = [ibm_is_vpc_address_prefix.prefix_z1]

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}



///////////////////////
//  Compute
///////////////////////


//-- SSH Key

data "ibm_is_ssh_key" "sshkey1" {
  name = "${var.ssh-key-name}"
}


//--- Web Server(s)

resource "ibm_is_instance" "web-instance" {
  count   = "${var.server-count}"
  name    = "${format(var.web-server-name-template-zone-1, count.index + 1)}"
  image   = "${var.image}"
  profile = "${var.profile}"

  primary_network_interface  {
    subnet = "${ibm_is_subnet.websubnet1.id}"
    security_groups = ["${ibm_is_security_group.public_facing_sg.id}"]
  }

  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone1}"
  keys = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  resource_group = "${data.ibm_resource_group.resource.id}"
  //user_data = "${data.template_cloudinit_config.cloud-init-config.rendered}"
  user_data = "${data.local_file.cloud-config-web-txt.content}"
  //user_data = file("${path.module}/web_a.cfg")
}

#---------------------------------------------------------
# Assign floating IPs To Webservers
#---------------------------------------------------------

resource "ibm_is_floating_ip" "vpc-a-webserver-zone1-fip" {
  count   = "${var.server-count}"
  name    = "${format(var.web-server-name-template-zone-1, count.index + 1)}-${var.zone1}-fip"
  target  = "${element(ibm_is_instance.web-instance.*.primary_network_interface.0.id, count.index)}"
}