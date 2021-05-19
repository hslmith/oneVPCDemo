// security group creation
//Allows ports 80, 22 and ICMP Ping


resource "ibm_is_security_group" "public_facing_sg" {
    name = "${var.vpc-name}-public-facing-sg1"
    vpc  = "${ibm_is_vpc.vpc1.id}"
}

resource "ibm_is_security_group_rule" "public_facing_tcp22" {
    group = "${ibm_is_security_group.public_facing_sg.id}"
    direction = "inbound"
    remote = "0.0.0.0/0"
    tcp = {
      port_min = "22"
      port_max = "22"
    }
}

resource "ibm_is_security_group_rule" "public_facing_sg_tcp80" {
    group = "${ibm_is_security_group.public_facing_sg.id}"
    direction = "inbound"
    remote = "0.0.0.0/0"
    tcp = {
      port_min = "80"
      port_max = "80"
    }
}

resource "ibm_is_security_group_rule" "public_facing_icmp" {
    group = "${ibm_is_security_group.public_facing_sg.id}"
    direction = "inbound"
    remote = "0.0.0.0/0"
    icmp = {
      code = "0"
      type = "8"
    }
}

resource "ibm_is_security_group_rule" "public_facing_egress" {
    group = "${ibm_is_security_group.public_facing_sg.id}"
    direction = "outbound"
    remote = "0.0.0.0/0"
}