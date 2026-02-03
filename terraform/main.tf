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

variable "affinity_host_id" {
  description = "UUID de l'hôte XCP-ng pour affinity (format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx). Dans XOA : Pools > votre pool > Hosts > clic sur l'hôte > UUID. Ne pas entrer 'yes' ici."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.affinity_host_id))
    error_message = "affinity_host_id doit être l'UUID de l'hôte (ex: a1b2c3d4-e5f6-7890-abcd-ef1234567890). Dans XOA : Pools > votre pool > Hosts > clic sur l'hôte > copier l'UUID. Ne pas entrer 'yes' (réserver pour la confirmation du plan)."
  }
}

variable "template_rocky" {
  description = "UUID du template Rocky Linux (XOA > Templates)"
  type        = string
  default     = "a00108b8-aac6-5f74-fe01-b25760ff2034"
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
  hvm_boot_firmware = "uefi" # Force le démarrage en UEFI (indispensable pour Rocky 9 récent)
  affinity_host = var.affinity_host_id

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
    password: commetuveuxmechein
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
  # Disable SELinux
  - setenforce 0
  - sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
  - firewall-cmd --permanent --add-port=80/tcp
  - firewall-cmd --permanent --add-port=80/udp
  - firewall-cmd --reload
  - chmod 600 /etc/NetworkManager/system-connections/enX0.nmconnection
  - nmcli connection delete "System enX0" || true
  - nmcli connection delete "Wired connection 1" || true
  
  # On active ta configuration propre
  - nmcli c reload
  - nmcli c up enX0
  - systemctl enable --now nginx
  # Config simple reverse proxy (exemple)
  - echo 'server { listen 80; server_name cours.hostaria.cloud; location / { proxy_pass http://10.200.0.200:80; proxy_set_header Host $host; proxy_set_header X-Real-IP $remote_addr; proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; } }' > /etc/nginx/conf.d/reverse.conf
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
  hvm_boot_firmware = "uefi" # Force le démarrage en UEFI (indispensable pour Rocky 9 récent)
  affinity_host = var.affinity_host_id

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
    password: commetuveuxmechein
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
        
          environment:
            WORDPRESS_DB_HOST: db:3306
            WORDPRESS_DB_USER: wordpress
            WORDPRESS_DB_PASSWORD: securepasswp
            WORDPRESS_DB_NAME: wordpress
      volumes:
        db_data:

runcmd:
  # Disable SELinux
  - setenforce 0
  - sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
  # Config Réseau
  - chmod 600 /etc/NetworkManager/system-connections/enX0.nmconnection
  - nmcli connection delete "System enX0" || true
  - nmcli connection delete "Wired connection 1" || true
  
  # On active ta configuration propre
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
  hvm_boot_firmware = "uefi" # Force le démarrage en UEFI (indispensable pour Rocky 9 récent)
  affinity_host = var.affinity_host_id

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
    password: commetuveuxmechein
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
      name: patchmon

      services:
        database:
          image: postgres:17-alpine
          restart: unless-stopped
          environment:
            POSTGRES_DB: patchmon_db
            POSTGRES_USER: patchmon_user
            POSTGRES_PASSWORD: StrongDBPassword123! # Mot de passe DB
          volumes:
            - postgres_data:/var/lib/postgresql/data
          networks:
            - patchmon-internal
          healthcheck:
            test: ["CMD-SHELL", "pg_isready -U patchmon_user -d patchmon_db"]
            interval: 3s
            timeout: 5s
            retries: 7

        redis:
          image: redis:7-alpine
          restart: unless-stopped
          command: redis-server --requirepass StrongRedisPassword456! # Mot de passe Redis
          volumes:
            - redis_data:/data
          networks:
            - patchmon-internal
          healthcheck:
            test: ["CMD", "redis-cli", "--no-auth-warning", "-a", "StrongRedisPassword456!", "ping"]
            interval: 3s
            timeout: 5s
            retries: 7

        backend:
          image: ghcr.io/patchmon/patchmon-backend:latest
          restart: unless-stopped
          environment:
            LOG_LEVEL: info
            DATABASE_URL: postgresql://patchmon_user:StrongDBPassword123!@database:5432/patchmon_db
            JWT_SECRET: 7f8e9d1c2b3a4f5e6d7c8b9a0f1e2d3c4b5a6f7e8d9c0b1a2f3e4d5c6b7a8f9 # Secret JWT généré
            SERVER_PROTOCOL: http
            SERVER_HOST: 10.200.0.199 # IP de la VM Monitoring
            SERVER_PORT: 3000
            CORS_ORIGIN: http://10.200.0.199:3000
            # Database Connection Pool
            DB_CONNECTION_LIMIT: 30
            DB_POOL_TIMEOUT: 20
            DB_CONNECT_TIMEOUT: 10
            DB_IDLE_TIMEOUT: 300
            DB_MAX_LIFETIME: 1800
            # Rate Limiting
            RATE_LIMIT_WINDOW_MS: 900000
            RATE_LIMIT_MAX: 5000
            AUTH_RATE_LIMIT_WINDOW_MS: 600000
            AUTH_RATE_LIMIT_MAX: 500
            AGENT_RATE_LIMIT_WINDOW_MS: 60000
            AGENT_RATE_LIMIT_MAX: 1000
            # Redis Configuration
            REDIS_HOST: redis
            REDIS_PORT: 6379
            REDIS_PASSWORD: StrongRedisPassword456!
            REDIS_DB: 0
            ASSETS_DIR: /app/assets
          volumes:
            - agent_files:/app/agents
            - branding_assets:/app/assets
          networks:
            - patchmon-internal
          depends_on:
            database:
              condition: service_healthy
            redis:
              condition: service_healthy

        frontend:
          image: ghcr.io/patchmon/patchmon-frontend:latest
          restart: unless-stopped
          ports:
            - "3000:3000"
          volumes:
            - branding_assets:/usr/share/nginx/html/assets
          networks:
            - patchmon-internal
          depends_on:
            backend:
              condition: service_healthy

      volumes:
        postgres_data:
        redis_data:
        agent_files:
        branding_assets:

      networks:
        patchmon-internal:
          driver: bridge

runcmd:
  # Disable SELinux
  - setenforce 0
  - sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
  # Config Réseau
  - chmod 600 /etc/NetworkManager/system-connections/enX0.nmconnection
  - nmcli connection delete "System enX0" || true
  - nmcli connection delete "Wired connection 1" || true
  
  # On active ta configuration propre
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

# --- 4. VM MASTER-1 (sans installation) ---
resource "xenorchestra_vm" "kube-master-1" {
  memory_max = 6710886400 # 6GB
  cpus       = 4
  name_label = "SRV-MASTER-01"
  name_description = "Master-1 - 10.200.0.201"
  template   = var.template_rocky
  hvm_boot_firmware = "uefi"
  affinity_host = var.affinity_host_id

  network {
    network_id = var.network_app_id
    mac_address = "02:00:00:00:00:04"
  }

  disk {
    sr_id      = var.sr_id
    name_label = "Rocky Linuaqwf"
    size       = 32212254720 # 30GB
  }

  cloud_config = <<EOF
#cloud-config
hostname: master-1
users:
  - name: admin-sys
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL8fEzs9QTcGOAl62I/QF5wWy6bCvdhdEknxUuBHedE2PNgT5zhgIu0qZUDqHElLUF22SXrAwbDdQYUrLJNndYblBg1B4Pj4sakkxDne0X56YEuANcS6CNieyTZZcUW0d/iaNbinKACZbcFIFNa+GvDwPMcco2GIBiQenPlrcGBH3gLX/vlX3rTH0fvoAo2B1PMvxhls8XADCUOFEU5HTKPMDdsX5wxgmqT7Ukbmz9rFUfCvyPUoDESaBi3y8UhWmZH1VeSsYyF8l9IGngLvUnyQKzSqnH0ysgwTIfmz/5ARW8DCAdPeCMkqvu7qQCd0JjBPhLjeF713GFNanR81bG2r+jecThlIC5pt6WZTxtqSyPtAguhcwmYNfj5gGbkqtiT/R6zcTIqoW1N6KrwQCRuDZkDDB0ILpyDPh8E/VJBTAccLDlJ0V69jUUnpgTwgSijW/wXuGxzH5riN2TjTBqR8Aci7jAWdy3hAVs7Rb3rhwVyWhXw1//uTxm4DUDDRM= dreasy@Maxou-9.local

chpasswd:
  list: |
    admin-sys:commetuveuxmechein
  expire: false

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
      address1=10.200.0.201/24,10.200.0.254
      dns=1.1.1.1;
      [ipv6]
      method=ignore

runcmd:
  - setenforce 0
  - sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
  - chmod 600 /etc/NetworkManager/system-connections/enX0.nmconnection
  - nmcli connection delete "System enX0" || true
  - nmcli connection delete "Wired connection 1" || true
  
  # On active ta configuration propre
  - nmcli c reload
  - nmcli c up enX0
EOF
}

# --- 5. VM WORKER-1 (sans installation) ---
resource "xenorchestra_vm" "kube-worker-1" {
  memory_max = 2147483648 # 2GB
  cpus       = 2
  name_label = "SRV-WORKER-01"
  name_description = "Worker-1 - 10.200.0.202"
  template   = var.template_rocky
  hvm_boot_firmware = "uefi"
  affinity_host = var.affinity_host_id

  network {
    network_id = var.network_app_id
    mac_address = "02:00:00:00:00:05"
  }

  disk {
    sr_id      = var.sr_id
    name_label = "Rocky Linuaqwf"
    size       = 32212254720 # 30GB
  }

  cloud_config = <<EOF
#cloud-config
hostname: kube-worker-1
users:
  - name: admin-sys
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL8fEzs9QTcGOAl62I/QF5wWy6bCvdhdEknxUuBHedE2PNgT5zhgIu0qZUDqHElLUF22SXrAwbDdQYUrLJNndYblBg1B4Pj4sakkxDne0X56YEuANcS6CNieyTZZcUW0d/iaNbinKACZbcFIFNa+GvDwPMcco2GIBiQenPlrcGBH3gLX/vlX3rTH0fvoAo2B1PMvxhls8XADCUOFEU5HTKPMDdsX5wxgmqT7Ukbmz9rFUfCvyPUoDESaBi3y8UhWmZH1VeSsYyF8l9IGngLvUnyQKzSqnH0ysgwTIfmz/5ARW8DCAdPeCMkqvu7qQCd0JjBPhLjeF713GFNanR81bG2r+jecThlIC5pt6WZTxtqSyPtAguhcwmYNfj5gGbkqtiT/R6zcTIqoW1N6KrwQCRuDZkDDB0ILpyDPh8E/VJBTAccLDlJ0V69jUUnpgTwgSijW/wXuGxzH5riN2TjTBqR8Aci7jAWdy3hAVs7Rb3rhwVyWhXw1//uTxm4DUDDRM= dreasy@Maxou-9.local

chpasswd:
  list: |
    admin-sys:commetuveuxmechein
  expire: false

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
      address1=10.200.0.202/24,10.200.0.254
      dns=1.1.1.1;
      [ipv6]
      method=ignore

runcmd:
  - setenforce 0
  - sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
  - chmod 600 /etc/NetworkManager/system-connections/enX0.nmconnection
  - nmcli connection delete "System enX0" || true
  - nmcli connection delete "Wired connection 1" || true
  
  # On active ta configuration propre
  - nmcli c reload
  - nmcli c up enX0
EOF
}

# --- 6. VM WORKER-2 (sans installation) ---
resource "xenorchestra_vm" "kube-worker-2" {
  memory_max = 2147483648 # 2GB
  cpus       = 2
  name_label = "SRV-WORKER-02"
  name_description = "Worker-2 - 10.200.0.203"
  template   = var.template_rocky
  hvm_boot_firmware = "uefi"
  affinity_host = var.affinity_host_id

  network {
    network_id = var.network_app_id
    mac_address = "02:00:00:00:00:06"
  }

  disk {
    sr_id      = var.sr_id
    name_label = "Rocky Linuaqwf"
    size       = 32212254720 # 30GB
  }

  cloud_config = <<EOF
#cloud-config
hostname: worker-2
users:
  - name: admin-sys
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL8fEzs9QTcGOAl62I/QF5wWy6bCvdhdEknxUuBHedE2PNgT5zhgIu0qZUDqHElLUF22SXrAwbDdQYUrLJNndYblBg1B4Pj4sakkxDne0X56YEuANcS6CNieyTZZcUW0d/iaNbinKACZbcFIFNa+GvDwPMcco2GIBiQenPlrcGBH3gLX/vlX3rTH0fvoAo2B1PMvxhls8XADCUOFEU5HTKPMDdsX5wxgmqT7Ukbmz9rFUfCvyPUoDESaBi3y8UhWmZH1VeSsYyF8l9IGngLvUnyQKzSqnH0ysgwTIfmz/5ARW8DCAdPeCMkqvu7qQCd0JjBPhLjeF713GFNanR81bG2r+jecThlIC5pt6WZTxtqSyPtAguhcwmYNfj5gGbkqtiT/R6zcTIqoW1N6KrwQCRuDZkDDB0ILpyDPh8E/VJBTAccLDlJ0V69jUUnpgTwgSijW/wXuGxzH5riN2TjTBqR8Aci7jAWdy3hAVs7Rb3rhwVyWhXw1//uTxm4DUDDRM= dreasy@Maxou-9.local

chpasswd:
  list: |
    admin-sys:commetuveuxmechein
  expire: false

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
      address1=10.200.0.203/24,10.200.0.254
      dns=1.1.1.1;
      [ipv6]
      method=ignore

runcmd:
  - setenforce 0
  - sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
  - chmod 600 /etc/NetworkManager/system-connections/enX0.nmconnection
  - nmcli connection delete "System enX0" || true
  - nmcli connection delete "Wired connection 1" || true
  
  # On active ta configuration propre
  - nmcli c up enX0
  - nmcli c reload
EOF
}
