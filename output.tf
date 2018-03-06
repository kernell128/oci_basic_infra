
output "nginx_ip" {
  value = ["${data.oci_core_vnic.nginxVnic.public_ip_address}"]
}

output "httpd_ip" {
  value = ["${data.oci_core_vnic.srv1Vnic.public_ip_address}"]
}
