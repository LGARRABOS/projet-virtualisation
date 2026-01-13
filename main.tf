terraform {
  required_providers {
    xenorchestra = {
      source = "terra-farm/xenorchestra"
      version = "~> 0.23.0"
    } 
  }
}

provider "xenorchestra" {
  url      = "ws://10.200.0.10"
  username = "Dreasy"
  password = "Dreasy33@"
  insecure = true
}

# --- VARIABLES ---
variable "sr_id" {
  default = "2d27fd89-3cdf-e345-4cbe-0476d65d48a1"
}

# On suppose qu'il y a 2 réseaux (interfaces) différents dans XCP-ng
# Ou alors c'est le même réseau physique avec des VLANs taggés dans la VM
# Ici je vais utiliser 2 variables d'ID réseau distinctes
variable "network_dmz_id" {
  description = "Réseau 10.99.0.0/24"
  default = "652c5523-c28a-f1a9-f739-f360b7881730"
}

variable "network_app_id" {
  description = "Réseau 10.200.0.0/24"
  default = "82602d24-efdd-d5f0-f983-1a2d867907bb"
}

variable "template_rocky" {
  default = "a00108b8-aac6-5f74-fe01-b25760ff2034"
}

variable "pool_id" {
  description = "838d0c46-b7a9-85e4-0c71-3c3a3f57dd84"
  default = "838d0c46-b7a9-85e4-0c71-3c3a3f57dd84" # Laisser vide pour auto-détection, ou mettre l'UUID du pool
}

# Récupérer un hôte du pool pour l'affinité
data "xenorchestra_hosts" "hosts" {
  pool_id = var.pool_id
}

# Générer des MAC addresses pour les interfaces réseau (format 02:XX:XX:XX:XX:XX)
# Utilisation de random_id pour générer des bytes, puis formatage en MAC
resource "random_id" "mac_rp" {
  byte_length = 5
}

resource "random_id" "mac_wp" {
  byte_length = 5
}

resource "random_id" "mac_mon" {
  byte_length = 5
}

# --- 1. VM REVERSE PROXY (NGINX) ---
resource "xenorchestra_vm" "reverse_proxy" {
  memory_max = 4294967296 #4GB
  cpus       = 4
  name_label = "SRV-RP-NGINX-01"
  name_description = "Reverse Proxy Nginx - 10.199.0.200"
  template   = var.template_rocky
  affinity_host = data.xenorchestra_hosts.hosts.hosts[0].id
  hvm_boot_firmware = "uefi" # Force le démarrage en UEFI (indispensable pour Rocky 9 récent)

  network {
    network_id = var.network_dmz_id
    mac_address = "02:00:00:00:00:01"
  }

  disk {
    sr_id      = var.sr_id
    name_label = "Rocky Linuaqwf"
    size       = 32212254720 # 30GB
  }

  cloud_config = <<EOF
#cloud-config
hostname: srv-rp-nginx-01
users:
  - name: admin-sys
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL8fEzs9QTcGOAl62I/QF5wWy6bCvdhdEknxUuBHedE2PNgT5zhgIu0qZUDqHElLUF22SXrAwbDdQYUrLJNndYblBg1B4Pj4sakkxDne0X56YEuANcS6CNieyTZZcUW0d/iaNbinKACZbcFIFNa+GvDwPMcco2GIBiQenPlrcGBH3gLX/vlX3rTH0fvoAo2B1PMvxhls8XADCUOFEU5HTKPMDdsX5wxgmqT7Ukbmz9rFUfCvyPUoDESaBi3y8UhWmZH1VeSsYyF8l9IGngLvUnyQKzSqnH0ysgwTIfmz/5ARW8DCAdPeCMkqvu7qQCd0JjBPhLjeF713GFNanR81bG2r+jecThlIC5pt6WZTxtqSyPtAguhcwmYNfj5gGbkqtiT/R6zcTIqoW1N6KrwQCRuDZkDDB0ILpyDPh8E/VJBTAccLDlJ0V69jUUnpgTwgSijW/wXuGxzH5riN2TjTBqR8Aci7jAWdy3hAVs7Rb3rhwVyWhXw1//uTxm4DUDDRM= dreasy@Maxou-9.local

# Config Réseau Statique (Rocky 9 utilise NetworkManager)
write_files:
  - path: /etc/NetworkManager/system-connections/enX0.nmconnection
    permissions: '0600'
    content: |
      [connection]
      id=enX0
      type=ethernet
      interface-name=enX0
      
      [ipv4]
      method=manual
      address1=10.199.0.200/24,10.199.0.254
      dns=1.1.1.1;8.8.8.8
      
      [ipv6]
      method=ignore

package_update: true
packages:
  - nginx
  - git

runcmd:
  - chmod 600 /etc/NetworkManager/system-connections/enX0.nmconnection
  - nmcli c reload
  - nmcli c up enX0
  - systemctl enable --now nginx
  # Config simple reverse proxy (exemple)
  - echo 'server { listen 80; server_name nova-solar.fr; location / { proxy_pass http://10.200.0.200:80; } }' > /etc/nginx/conf.d/reverse.conf
  - systemctl restart nginx
EOF
}

# --- 2. VM WORDPRESS (DOCKER COMPOSE) ---
resource "xenorchestra_vm" "wordpress_app" {
  memory_max = 8589934592 # 8GB
  cpus       = 4
  name_label = "SRV-APP-WP-01"
  name_description = "WordPress Docker - 10.100.0.200"
  template   = var.template_rocky
  affinity_host = data.xenorchestra_hosts.hosts.hosts[0].id
  hvm_boot_firmware = "uefi" # Force le démarrage en UEFI (indispensable pour Rocky 9 récent)

  network {
    network_id = var.network_app_id
    mac_address = "02:00:00:00:00:02"
  }

  disk {
    sr_id      = var.sr_id
    name_label = "Rocky Linuaqwf"
    size       = 32212254720 # 30GB
  }

  cloud_config = <<EOF
#cloud-config
hostname: srv-app-wp-01
users:
  - name: admin-sys
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL8fEzs9QTcGOAl62I/QF5wWy6bCvdhdEknxUuBHedE2PNgT5zhgIu0qZUDqHElLUF22SXrAwbDdQYUrLJNndYblBg1B4Pj4sakkxDne0X56YEuANcS6CNieyTZZcUW0d/iaNbinKACZbcFIFNa+GvDwPMcco2GIBiQenPlrcGBH3gLX/vlX3rTH0fvoAo2B1PMvxhls8XADCUOFEU5HTKPMDdsX5wxgmqT7Ukbmz9rFUfCvyPUoDESaBi3y8UhWmZH1VeSsYyF8l9IGngLvUnyQKzSqnH0ysgwTIfmz/5ARW8DCAdPeCMkqvu7qQCd0JjBPhLjeF713GFNanR81bG2r+jecThlIC5pt6WZTxtqSyPtAguhcwmYNfj5gGbkqtiT/R6zcTIqoW1N6KrwQCRuDZkDDB0ILpyDPh8E/VJBTAccLDlJ0V69jUUnpgTwgSijW/wXuGxzH5riN2TjTBqR8Aci7jAWdy3hAVs7Rb3rhwVyWhXw1//uTxm4DUDDRM= dreasy@Maxou-9.local

write_files:
  - path: /etc/NetworkManager/system-connections/enX0.nmconnection
    permissions: '0600'
    content: |
      [connection]
      id=enX0
      type=ethernet
      interface-name=enX0
      
      [ipv4]
      method=manual
      address1=10.200.0.200/24,10.200.0.254
      dns=1.1.1.1;
      
      [ipv6]
      method=ignore

  # Fichier Docker Compose WordPress
  - path: /opt/wordpress/docker-compose.yml
    content: |
      version: '3'
      services:
        db:
          image: mysql:5.7
          volumes:
            - db_data:/var/lib/mysql
          restart: always
          environment:
            MYSQL_ROOT_PASSWORD: securepassroot
            MYSQL_DATABASE: wordpress
            MYSQL_USER: wordpress
            MYSQL_PASSWORD: securepasswp
        
        wordpress:
          depends_on:
            - db
          image: wordpress:latest
          ports:
            - "80:80"
          restart: always
          deploy:
            replicas: 3
          environment:
            WORDPRESS_DB_HOST: db:3306
            WORDPRESS_DB_USER: wordpress
            WORDPRESS_DB_PASSWORD: securepasswp
            WORDPRESS_DB_NAME: wordpress
      volumes:
        db_data:

runcmd:
  # Config Réseau
  - chmod 600 /etc/NetworkManager/system-connections/enX0.nmconnection
  - nmcli c reload
  - nmcli c up enX0
  
  # Install Docker
  - dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  - dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  - systemctl enable --now docker
  
  # Lancement App
  - cd /opt/wordpress && docker compose up -d
EOF
}

# --- 3. VM MONITORING (NETDATA/PATCHMON) ---
resource "xenorchestra_vm" "monitoring" {
  memory_max = 4294967296 # 4GB
  cpus       = 4
  name_label = "SRV-MONIT-01"
  name_description = "Netdata & Patchmon - 10.200.0.199"
  template   = var.template_rocky
  affinity_host = data.xenorchestra_hosts.hosts.hosts[0].id
  hvm_boot_firmware = "uefi" # Force le démarrage en UEFI (indispensable pour Rocky 9 récent)

  network {
    network_id = var.network_app_id
    mac_address = "02:00:00:00:00:03"
  }

  disk {
    sr_id      = var.sr_id
    name_label = "Rocky Linuaqwf"
    size       = 32212254720 # 30GB
  }

  cloud_config = <<EOF
#cloud-config
hostname: srv-monit-01
users:
  - name: admin-sys
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL8fEzs9QTcGOAl62I/QF5wWy6bCvdhdEknxUuBHedE2PNgT5zhgIu0qZUDqHElLUF22SXrAwbDdQYUrLJNndYblBg1B4Pj4sakkxDne0X56YEuANcS6CNieyTZZcUW0d/iaNbinKACZbcFIFNa+GvDwPMcco2GIBiQenPlrcGBH3gLX/vlX3rTH0fvoAo2B1PMvxhls8XADCUOFEU5HTKPMDdsX5wxgmqT7Ukbmz9rFUfCvyPUoDESaBi3y8UhWmZH1VeSsYyF8l9IGngLvUnyQKzSqnH0ysgwTIfmz/5ARW8DCAdPeCMkqvu7qQCd0JjBPhLjeF713GFNanR81bG2r+jecThlIC5pt6WZTxtqSyPtAguhcwmYNfj5gGbkqtiT/R6zcTIqoW1N6KrwQCRuDZkDDB0ILpyDPh8E/VJBTAccLDlJ0V69jUUnpgTwgSijW/wXuGxzH5riN2TjTBqR8Aci7jAWdy3hAVs7Rb3rhwVyWhXw1//uTxm4DUDDRM= dreasy@Maxou-9.local

write_files:
  - path: /etc/NetworkManager/system-connections/enX0.nmconnection
    permissions: '0600'
    content: |
      [connection]
      id=enX0
      type=ethernet
      interface-name=enX0
      
      [ipv4]
      method=manual
      address1=10.200.0.199/24,10.200.0.254
      dns=1.1.1.1;
      
      [ipv6]
      method=ignore
  
  # 1. Netdata (Monitoring)
  - path: /opt/netdata/docker-compose.yml
    content: |
      version: '3'
      services:
        netdata:
          image: netdata/netdata
          container_name: netdata
          hostname: srv-monit-01
          ports:
            - 19999:19999
          restart: unless-stopped
          cap_add:
            - SYS_PTRACE
          security_opt:
            - apparmor:unconfined
          volumes:
            - netdatalib:/var/lib/netdata
            - netdatacache:/var/cache/netdata
            - /etc/passwd:/host/etc/passwd:ro
            - /etc/group:/host/etc/group:ro
            - /proc:/host/proc:ro
            - /sys:/host/sys:ro
            - /etc/os-release:/host/etc/os-release:ro
      volumes:
        netdatalib:
        netdatacache:

  # 2. Patchmon (Gestion Patchs)
  - path: /opt/patchmon/docker-compose.yml
    content: |
      version: '3.8'

      services:
        database:
          image: postgres:17-alpine
          container_name: patchmon-postgres
          restart: unless-stopped
          environment:
            POSTGRES_DB: patchmon_db
            POSTGRES_USER: patchmon_user
            POSTGRES_PASSWORD: password_fort_db # À CHANGER
          volumes:
            - postgres_data:/var/lib/postgresql/data
          networks:
            - patchmon-internal
          healthcheck:
            test: ["CMD-SHELL", "pg_isready -U patchmon_user -d patchmon_db"]
            interval: 10s
            timeout: 5s
            retries: 5

        redis:
          image: redis:7-alpine
          container_name: patchmon-redis
          restart: unless-stopped
          command: redis-server --requirepass password_fort_redis # À CHANGER
          networks:
            - patchmon-internal

        backend:
          image: ghcr.io/patchmon/patchmon-backend:latest
          container_name: patchmon-backend
          restart: unless-stopped
          depends_on:
            database:
              condition: service_healthy
            redis:
              condition: service_started
          environment:
            # Configuration DB
            DB_HOST: database
            DB_PORT: 5432
            DB_NAME: patchmon_db
            DB_USER: patchmon_user
            DB_PASSWORD: password_fort_db # Doit correspondre à la DB
            # Configuration Redis
            REDIS_HOST: redis
            REDIS_PORT: 6379
            REDIS_PASSWORD: password_fort_redis # Doit correspondre à Redis
            # Sécurité
            JWT_SECRET: secret_jwt_tres_long # À CHANGER (clé aléatoire)
            # URL de l'instance
            SERVER_PROTOCOL: http # ou https
            SERVER_HOST: 10.200.0.199 # IP de la VM
            SERVER_PORT: 4000
          networks:
            - patchmon-internal

        frontend:
          image: ghcr.io/patchmon/patchmon-frontend:latest
          container_name: patchmon-frontend
          restart: unless-stopped
          ports:
            - "3000:3000"
          depends_on:
            - backend
          environment:
            BACKEND_URL: http://backend:4000 # Communication interne
          networks:
            - patchmon-internal

      networks:
        patchmon-internal:
          driver: bridge

      volumes:
        postgres_data:

runcmd:
  # Config Réseau
  - chmod 600 /etc/NetworkManager/system-connections/enX0.nmconnection
  - nmcli c reload
  - nmcli c up enX0
  
  # Install Docker
  - dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  - dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  - systemctl enable --now docker
  
  # Lancement Netdata
  - cd /opt/netdata && docker compose up -d
  
  # Lancement Patchmon
  - cd /opt/patchmon && docker compose up -d
EOF
}
