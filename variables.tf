////////////////
//Define Zones
////////////////

variable "ibmcloud_region" {
  description = "Preferred IBM Cloud region to use for your infrastructure"
  default = "us-south"
}

variable "zone1" {
  default = "us-south-1"
  description = "Define the 1st zone of the region"
}


variable "vpc-name" {
  default = "basic-vpc-demo"
  description = "Name of your VPC"
}


////////////////
// Define CIDR
////////////////


variable "vpc-address-prefix" {
  default = "192.168.0.0/20"
}

variable "az1-prefix" {
  default = "192.168.0.0/21"
  description = "CIDR block to be used for zone 1"
}


//-- Define Subnets for zones


variable "subnet-zone1" {
  default = "192.168.0.0/24"
}

//////////////////
// Define SSH Key
//////////////////

variable "ssh-key-name" {
  default = "default"
  description = "Name of existing VPC SSH Key"
}



//////////////////
// Define ENV
//////////////////

variable "resource_group" {
  default = "Default"
}

variable "server-count" {
  default = 1
}


variable "image" {
  // CENT7
  //default = "r006-e0039ab2-fcc8-11e9-8a36-6ffb6501dd33"
  default = "r006-14140f94-fcc4-11e9-96e7-a72723715315"
  description = "OS Image ID to be used for virtual instances"
}

variable "profile" {
  default = "cx2-2x4"
  description = "Instance profile to be used for virtual instances"
}

variable "web-server-name-template-zone-1" {
  default = "server-1%03d"
}