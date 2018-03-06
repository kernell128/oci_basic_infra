resource "oci_core_virtual_network" "vcn-1" {
  cidr_block = "${var.vcn-1_cdir}"
  dns_label = "${var.vcn-1_name}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.vcn-1_name}"
}

resource "oci_core_internet_gateway" "igw" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "igw"
    vcn_id = "${oci_core_virtual_network.vcn-1.id}"
}

resource "oci_core_route_table" "rt-webpub" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_virtual_network.vcn-1.id}"
    display_name = "rt-pub"
    route_rules {
        cidr_block = "0.0.0.0/0"
        network_entity_id = "${oci_core_internet_gateway.igw.id}"
    }
}

resource "oci_core_route_table" "rt-webdmz" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_virtual_network.vcn-1.id}"
    display_name = "rt-dmz"
    route_rules {
        cidr_block = "0.0.0.0/0"
        network_entity_id = "${oci_core_internet_gateway.igw.id}"
    }
}
resource "oci_core_security_list" "sl-webpub" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "Web Public"
    vcn_id = "${oci_core_virtual_network.vcn-1.id}"
    egress_security_rules = [{
    protocol    = "all"
    destination = "0.0.0.0/0"
    }]
    ingress_security_rules = [{
        tcp_options {
            "max" = 80
            "min" = 80
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
	{
	protocol = "6"
	source = "${var.vcn-1_cdir}"
    },
    {
      tcp_options {
          "max" = 22
          "min" = 22
      }
      protocol = "6"
      source = "0.0.0.0/0"
      }]
}
resource "oci_core_security_list" "sl-webdmz" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "Web DMZ"
    vcn_id = "${oci_core_virtual_network.vcn-1.id}"
    egress_security_rules = [{
    protocol    = "all"
    destination = "0.0.0.0/0"
    }]
    ingress_security_rules = [{
        tcp_options {
            "max" = 80
            "min" = 80
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
	{
	protocol = "6"
	source = "${var.vcn-1_cdir}"
    },
    {
      tcp_options {
          "max" = 22
          "min" = 22
      }
      protocol = "6"
      source = "0.0.0.0/0"
      }]
}

resource "oci_core_subnet" "WebDMZSubnetAD1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block = "${var.WebDMZSubnetAD1_cdir}"
  display_name = "${var.WebDMZSubnetAD1_name}"
  dns_label  = "${var.WebDMZSubnetAD1_name}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.vcn-1.id}"
  route_table_id = "${oci_core_route_table.rt-webdmz.id}"
  security_list_ids = ["${oci_core_security_list.sl-webdmz.id}"]
  dhcp_options_id = "${oci_core_virtual_network.vcn-1.default_dhcp_options_id}"
  provisioner "local-exec" {
      command = "sleep 5"
    }
}
resource "oci_core_subnet" "WebPubSubnetAD1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block = "${var.WebPubSubnetAD1_cdir}"
  display_name = "${var.WebPubSubnetAD1_name}"
  dns_label  = "${var.WebPubSubnetAD1_name}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.vcn-1.id}"
  route_table_id = "${oci_core_route_table.rt-webpub.id}"
  security_list_ids = ["${oci_core_security_list.sl-webpub.id}"]
  dhcp_options_id = "${oci_core_virtual_network.vcn-1.default_dhcp_options_id}"
  provisioner "local-exec" {
      command = "sleep 5"
    }
}
