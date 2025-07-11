
terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.12.0"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region            = "us-south"
}

resource "ibm_is_instance" "vuln_vm" {
  name              = "vuln-vm"
  profile           = "bx2-2x8"
  zone              = "us-south-1"
  image             = "r006-3c66e1c3-57cc-4edb-9115-a31737d26a10" # Update as needed

  primary_network_interface {
    subnet = ibm_is_subnet.vuln_subnet.id
  }

  vpc           = ibm_is_vpc.vuln_vpc.id
  boot_volume {
    encryption = "none"
  }

  metadata_service_enabled = true
}

resource "ibm_is_vpc" "vuln_vpc" {
  name                      = "vuln-vpc"
  classic_access            = true
  address_prefix_management = "manual"
}

resource "ibm_is_subnet" "vuln_subnet" {
  name           = "vuln-subnet"
  vpc            = ibm_is_vpc.vuln_vpc.id
  zone           = "us-south-1"
  ipv4_cidr_block = "10.240.0.0/24"
  public_gateway  = ibm_is_public_gateway.vuln_gw.id
}

resource "ibm_is_public_gateway" "vuln_gw" {
  name = "vuln-gw"
  vpc  = ibm_is_vpc.vuln_vpc.id
  zone = "us-south-1"
}
