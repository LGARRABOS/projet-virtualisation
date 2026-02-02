# Processus de Déploiement Infrastructure (XCP-ng + TrueNAS + IaC)

Ce document détaille la procédure technique pour monter le socle de virtualisation, le stockage, et automatiser le déploiement des services d'administration (XOA) et de monitoring (Netdata).

---

## 1. Installation du Socle Physique (Manuel)

### A. Stockage : TrueNAS Core (Backup & Fichiers)
*Objectif : Fournir un espace de stockage sécurisé pour les sauvegardes des VMs et les fichiers utilisateurs.*

1.  **Installation OS :** Boot sur clé USB TrueNAS -> Install sur SSD dédié (Boot Pool).
2.  **Configuration Réseau (Console) :** Fixer IP Statique (ex: `192.168.10.5/24`).
3.  **Configuration Web UI :**
    *   Création du **Pool ZFS** (Full Flash SSD).
    *   Création du **Dataset** `backups-vms` et `fichiers-partages`.
    *   Activation du service **NFS** (pour les backups XCP-ng) et **SMB** (pour les utilisateurs Windows).

### B. Hyperviseur : XCP-ng (Stockage Local NVMe)
*Objectif : Le moteur de virtualisation avec stockage haute performance.*

1.  **Installation OS :** Boot sur ISO XCP-ng -> Install sur RAID NVMe Local.
2.  **Configuration Réseau :**
    *   IP Statique de management (ex: `192.168.10.10/24`).
3.  **Liaison Stockage (Backup) :**
    ```bash
    # Commande pour monter le Remote NFS pour les Backups (pas pour exécuter les VMs)
    # Ceci se fait généralement via l'interface XOA dans la section "Remotes"
    ```

---

## 2. Automatisation du Déploiement (Terraform + Cloud-Init)

*Nous n'allons pas installer XOA manuellement, mais utiliser Terraform pour le déployer "proprement" ainsi que les autres VMs.*

**Pré-requis :** Sur votre poste d'admin, installer `terraform` et `xo-cli` (ou utiliser l'API XCP-ng directement si possible, sinon bootstrap d'une VM temporaire).

*Note : Pour utiliser Terraform avec XCP-ng "nu" (sans XOA), c'est complexe car le provider Terraform communique souvent avec l'API XOA. La méthode "Bootstrap" consiste à déployer XOA manuellement en 1 ligne, puis utiliser Terraform pour le reste.*

### A. Bootstrap XOA (La méthode rapide)
Sur l'hôte XCP-ng (en SSH) :
```bash
bash -c "$(curl -s http://xoa.io/deploy)"
# Suivre l'assistant pour déployer la version Free/Community
# IP XOA : 192.168.10.11
```

### B. Configuration Terraform (Pour VM Netdata & autres)
Créez un dossier `iac/` avec `main.tf` :

```hcl
terraform {
  required_providers {
    xenorchestra = {
      source = "terra-farm/xenorchestra"
      version = "~> 0.23.0"
    }
  }
}

provider "xenorchestra" {
  url      = "ws://192.168.10.11" # IP de votre XOA
  username = "admin@admin.net"
  password = "adminpassword"
  insecure = true # Si certificat auto-signé
}

# Déclaration de la VM Netdata
resource "xenorchestra_vm" "netdata_monitor" {
  memory_max = 2147483648 # 2GB
  cpus       = 2
  name_label = "Netdata-Monitor"
  template   = "Debian 11" # Nom du template dans XCP-ng

  network {
    network_id = "<UUID_DU_RESEAU>"
  }

  disk {
    sr_id      = "<UUID_DU_SR_LOCAL_NVME>"
    name_label = "Netdata Disk"
    size       = 21474836480 # 20GB
  }

  # Cloud-Init pour l'auto-config
  cloud_config = <<EOF
#cloud-config
hostname: netdata-server
users:
  - name: admin
    ssh-authorized-keys:
      - ssh-rsa AAAAB3Nza... (Votre Clé Publique)
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash

package_update: true
packages:
  - curl
  - git

runcmd:
  # Installation automatique de Netdata One-Liner
  - wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh
  - sh /tmp/netdata-kickstart.sh --non-interactive
EOF
}
```

### C. Déploiement
```bash
terraform init
terraform plan
terraform apply
```
> **Résultat :** Terraform parle à XOA, clone le template Debian, crée la VM sur le stockage Local NVMe, et Cloud-Init installe Netdata tout seul au premier boot.

---

## 3. Configuration Avancée (Ansible)
*Si la config Cloud-Init est trop basique, on passe la main à Ansible une fois la VM UP.*

**Fichier `inventory.ini` :**
```ini
[monitoring]
192.168.10.20 # IP récupérée de la VM Netdata
```

**Playbook `setup_netdata.yml` :**
```yaml
- name: Configure Netdata
  hosts: monitoring
  become: yes
  tasks:
    - name: Copier la config Netdata
      copy:
        src: ./netdata.conf
        dest: /etc/netdata/netdata.conf
      notify: Restart Netdata

  handlers:
    - name: Restart Netdata
      service:
        name: netdata
        state: restarted
```
