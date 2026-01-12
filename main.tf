terraform {
  required_providers {
    xenorchestra = {
      source = "terra-farm/xenorchestra"
      version = "~> 0.23.0"
    }
  }
}

# Configuration de la connexion à XOA
provider "xenorchestra" {
  url      = "ws://192.168.10.11" # IP de votre XOA
  username = "admin@admin.net"    # Login XOA
  password = "adminpassword"      # Password XOA
  insecure = true                 # True si certificat auto-signé
}

# --- VARIABLES ---
variable "pool_id" {
  type    = string
  default = "UUID_DU_POOL_XCPNG" # À remplacer par l'UUID réel
}

variable "sr_id" {
  type    = string
  default = "UUID_DU_SR_NVME"    # UUID du stockage local NVMe
}

variable "network_id" {
  type    = string
  default = "UUID_DU_RESEAU"     # UUID du réseau (ex: eth0 ou VLAN)
}

variable "template_name" {
  type    = string
  default = "Debian 11"          # Nom exact du template dans XCP-ng
}

# --- VM MONITORING (NETDATA) ---
resource "xenorchestra_vm" "netdata" {
  memory_max = 4294967296 # 4GB RAM
  cpus       = 4
  name_label = "SRV-MONITORING-01"
  name_description = "Serveur Netdata - Monitoring Infra"
  template   = var.template_name
  
  network {
    network_id = var.network_id
  }

  disk {
    sr_id      = var.sr_id
    name_label = "OS Disk"
    size       = 21474836480 # 20GB
  }

  cloud_config = <<EOF
#cloud-config
hostname: srv-monitoring-01
package_update: true
packages:
  - curl
runcmd:
  # Installation automatique Netdata
  - wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh
  - sh /tmp/netdata-kickstart.sh --non-interactive
EOF
}

# --- VM WORDPRESS (MIGRATION WIX) ---
resource "xenorchestra_vm" "wordpress" {
  memory_max = 8589934592 # 8GB RAM (WordPress + BDD)
  cpus       = 8
  name_label = "SRV-WEB-01"
  name_description = "Hébergement Site Web (Migration Wix)"
  template   = var.template_name
  
  network {
    network_id = var.network_id
  }

  disk {
    sr_id      = var.sr_id
    name_label = "OS Disk"
    size       = 53687091200 # 50GB
  }

  # Cloud-Init pour installer la stack LAMP (Linux Apache MySQL PHP)
  cloud_config = <<EOF
#cloud-config
hostname: srv-web-01
users:
  - name: admin-web
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3Nza... (VOTRE CLE PUBLIC)

package_update: true
packages:
  - apache2
  - mariadb-server
  - php
  - php-mysql
  - php-curl
  - php-gd
  - php-mbstring
  - php-xml
  - php-xmlrpc
  - unzip
  - wget

runcmd:
  # 1. Sécurisation MySQL (Simulée) & Création BDD
  - systemctl start mariadb
  - mysql -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  - mysql -e "GRANT ALL ON wordpress.* TO 'wp_user'@'localhost' IDENTIFIED BY 'PasswordSuperSecure123!';"
  - mysql -e "FLUSH PRIVILEGES;"

  # 2. Téléchargement WordPress
  - wget https://wordpress.org/latest.tar.gz -P /tmp
  - tar -xzvf /tmp/latest.tar.gz -C /var/www/html
  
  # 3. Configuration Apache
  - chown -R www-data:www-data /var/www/html/wordpress
  - chmod -R 755 /var/www/html/wordpress
  # Création d'un VirtualHost simple
  - echo '<VirtualHost *:80>' > /etc/apache2/sites-available/wordpress.conf
  - echo '    ServerAdmin admin@entreprise.com' >> /etc/apache2/sites-available/wordpress.conf
  - echo '    DocumentRoot /var/www/html/wordpress' >> /etc/apache2/sites-available/wordpress.conf
  - echo '    <Directory /var/www/html/wordpress>' >> /etc/apache2/sites-available/wordpress.conf
  - echo '        Options FollowSymLinks' >> /etc/apache2/sites-available/wordpress.conf
  - echo '        AllowOverride All' >> /etc/apache2/sites-available/wordpress.conf
  - echo '        Require all granted' >> /etc/apache2/sites-available/wordpress.conf
  - echo '    </Directory>' >> /etc/apache2/sites-available/wordpress.conf
  - echo '</VirtualHost>' >> /etc/apache2/sites-available/wordpress.conf
  
  - a2ensite wordpress
  - a2enmod rewrite
  - systemctl reload apache2
EOF
}
