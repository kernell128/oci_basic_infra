data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}
# HTTPD Get all Interfaces of instance
data "oci_core_vnic_attachments" "srv1Vnics" {
    compartment_id = "${var.compartment_ocid}"
    availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
    instance_id = "${oci_core_instance.srv1.id}"
}
# Gets the OCID of the first (default) vNIC
data "oci_core_vnic" "srv1Vnic" {
    vnic_id = "${lookup(data.oci_core_vnic_attachments.srv1Vnics.vnic_attachments[0],"vnic_id")}"
}

#NGINX Get all Interfaces of instance
data "oci_core_vnic_attachments" "nginxVnics" {
    compartment_id = "${var.compartment_ocid}"
    availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
    instance_id = "${oci_core_instance.nginx.id}"
}
# Gets the OCID of the first (default) vNIC
data "oci_core_vnic" "nginxVnic" {
    vnic_id = "${lookup(data.oci_core_vnic_attachments.nginxVnics.vnic_attachments[0],"vnic_id")}"
}
