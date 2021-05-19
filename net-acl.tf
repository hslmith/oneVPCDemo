resource "ibm_is_network_acl" "isBasicACL" {
  name = "${var.vpc-name}-webserver-acl"
  vpc  = "${ibm_is_vpc.vpc1.id}"

  rules {
    name        = "${var.vpc-name}-outbound-all"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
    tcp {
      port_max        = 65535
      port_min        = 1
      source_port_max = 60000
      source_port_min = 22
    }
  }
  rules {
    name        = "${var.vpc-name}-inbound-all"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "${var.vpc-address-prefix}"
    direction   = "inbound"
    tcp {
      port_max        = 65535
      port_min        = 1
      source_port_max = 60000
      source_port_min = 22
    }
  }

  }
}