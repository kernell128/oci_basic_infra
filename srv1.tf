resource "oci_core_instance" "srv1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "srv1"
  image = "${var.InstanceImageOCID[var.region]}"
  shape = "VM.Standard1.2"
  create_vnic_details {
    subnet_id = "${oci_core_subnet.WebPubSubnetAD1.id}"
    display_name = "srv1"
    assign_public_ip = true
    hostname_label = "srv1"
  },
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}
