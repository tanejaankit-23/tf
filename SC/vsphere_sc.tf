variable "vsphere_user" {default =""}
variable "vsphere_password" {default =""}
variable "vsphere_server" {default = "vvievc01.sbb01.spoc.global"}
variable "vsphere_num_cpus" {default ="2"}
variable "vsphere_memory" {default ="8192"}
variable "vsphere_vm_name" {default =""}
variable "vsphere_template_name" {default ="ubuntu-minimal-template"}
variable "vsphere_datecenter" {default ="Test"}

locals {
	id = "${random_integer.name_extension.result}"
}

resource "random_integer" "name_extension" {
  min     = 1
  max     = 99999
}

provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  
  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datecenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "extvimDatastorcluster/local Storage svievmw04"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Testcluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "Client_35"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_template_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "${var.vsphere_vm_name}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "Test"

  num_cpus = "${var.vsphere_num_cpus}"
  memory   = "${var.vsphere_memory}"
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 50
    thin_provisioned = true
  }
  
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }
}