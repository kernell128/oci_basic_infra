
resource "null_resource" "srv1-remote-exec" {
    depends_on = ["oci_core_instance.srv1"]
    provisioner "local-exec" {
      command = "sleep 5"
    }
    provisioner "file" {
      source      = "update.db"
      destination = "~opc/update.db"
    }
    connection {
      user = "opc"
      type = "ssh"
      private_key = "${var.ssh_private_key}"
      host = "${data.oci_core_vnic.srv1Vnic.public_ip_address}"
    }
    provisioner "file" {
      source      = "create.db"
      destination = "~opc/create.db"
    }
    connection {
      user = "opc"
      type = "ssh"
      private_key = "${var.ssh_private_key}"
      host = "${data.oci_core_vnic.srv1Vnic.public_ip_address}"
    }
    provisioner "file" {
      source      = "setpwd.db"
      destination = "~opc/setpwd.db"
    }
    connection {
      user = "opc"
      type = "ssh"
      private_key = "${var.ssh_private_key}"
      host = "${data.oci_core_vnic.srv1Vnic.public_ip_address}"
    }
    provisioner "remote-exec" {
      connection {
        agent = false
        timeout = "30m"
        host = "${data.oci_core_vnic.srv1Vnic.public_ip_address}"
        user = "opc"
        private_key = "${var.ssh_private_key}"
    }
      inline = [
        "echo \"LANG=en_US.utf-8\">>/etc/environment",
        "echo \"LC_ALL=en_US.utf-8\">>/etc/environment",
        "sudo rpm -ivh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm",
        "sudo yum install -y wget curl mod_ssl openssl httpd php php-mysql mlocate unzip php-gd php-xml php php-mysql mysql-community-server",
        "sudo systemctl enable  httpd.service",
        "sudo systemctl start  httpd.service",
        "sudo firewall-offline-cmd --add-service=http",
        "sudo systemctl enable   firewalld",
        "sudo systemctl restart  firewalld",
        "cd /tmp; wget https://wordpress.org/latest.tar.gz",
        "cd /var/www/html; sudo tar zxf /tmp/latest.tar.gz;cd wordpress;sudo mv -f * ../",
        "cd ..; sudo rmdir wordpress; sudo cp wp-config-sample.php wp-config.php",
        "sudo perl -pi -e \"s/database_name_here/wordpress/g\" wp-config.php",
        "sudo perl -pi -e \"s/username_here/wordpress/g\" wp-config.php",
        "sudo perl -pi -e \"s/password_here/_Wordpress2018/g\" wp-config.php",
        "sudo systemctl start mysqld",
        "sudo systemctl enable mysqld",
        "sudo systemctl set-environment MYSQLD_OPTS=--skip-grant-tables",
        "sudo systemctl restart mysqld",
        "sudo mysql -u root < ~opc/update.db",
        "sudo systemctl unset-environment MYSQLD_OPTS;sudo systemctl restart mysqld",
        "sudo mysql --user=root --password=_Wordpress2018 --connect-expired-password < ~opc/setpwd.db",
        "sudo mysql --user=root --password=_Wordpress2018 < ~opc/create.db",
        "touch ~opc/rp-userdata.`date +%s`.finish"
      ]
    }
}

resource "null_resource" "nginx-remote-exec" {
    depends_on = ["oci_core_instance.nginx"]
    provisioner "local-exec" {
      command = "sleep 5"
    }
    provisioner "file" {
      source      = "nginx.repo"
      destination = "~opc/nginx.repo"
    }
    connection {
      user = "opc"
      type = "ssh"
      private_key = "${var.ssh_private_key}"
      host = "${data.oci_core_vnic.nginxVnic.public_ip_address}"
    }
    provisioner "file" {
      source      = "nginx.conf"
      destination = "~opc/nginx.conf"
    }
    connection {
      user = "opc"
      type = "ssh"
      private_key = "${var.ssh_private_key}"
      host = "${data.oci_core_vnic.nginxVnic.public_ip_address}"
    }
    provisioner "remote-exec" {
      connection {
        agent = false
        timeout = "30m"
        host = "${data.oci_core_vnic.nginxVnic.public_ip_address}"
        user = "opc"
        private_key = "${var.ssh_private_key}"
    }
      inline = [
        "echo \"LANG=en_US.utf-8\">>/etc/environment",
        "echo \"LC_ALL=en_US.utf-8\">>/etc/environment",
        "sudo cp ~opc/nginx.repo /etc/yum.repos.d/nginx.repo",
        "sudo yum -y install nginx",
        "sudo systemctl enable nginx",
        "sudo systemctl start nginx",
        "sudo cp ~opc/nginx.conf /etc/nginx/nginx.conf",
        "sudo firewall-offline-cmd --add-service=http",
        "sudo systemctl enabled   firewalld",
        "sudo systemctl restart   firewalld",
        "sudo systemctl restart nginx",
        "touch ~opc/rp-userdata.`date +%s`.finish"
      ]
    }
}
