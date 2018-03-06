resource "oci_core_instance" "nginx" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "nginx"
  image = "${var.InstanceImageOCID[var.region]}"
  shape = "VM.Standard1.2"
  create_vnic_details {
    subnet_id = "${oci_core_subnet.WebDMZSubnetAD1.id}"
    display_name = "nginx"
    assign_public_ip = true
    hostname_label = "nginx"
  },
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}
