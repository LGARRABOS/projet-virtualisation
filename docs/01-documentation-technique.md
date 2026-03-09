# Documentation Technique – Infrastructure Virtualisation

**Public cible :** Administrateurs système, équipes DevOps, prestataires IT  
**Version :** 1.0  
**Dernière mise à jour :** Mars 2026

---

## 1. Vue d'ensemble de l'architecture

### 1.1 Stack technique

| Composant | Technologie |
|-----------|-------------|
| Hyperviseur | XCP-ng (Xen) |
| Orchestration VM | Xen Orchestra (XOA) |
| Infrastructure as Code | Terraform (provider `terra-farm/xenorchestra` ~0.23.0) |
| Configuration post-déploiement | Ansible |
| OS invités | Rocky Linux 9 |
| Conteneurisation | Docker, Docker Compose |
| Orchestration conteneurs | RKE2 (Rancher Kubernetes Engine 2) |
| Reverse proxy | Nginx |
| Monitoring | Netdata, Patchmon |

### 1.2 Schéma des VMs déployées

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                    XCP-ng (Hyperviseur)                  │
                    │                                                          │
  Internet          │   ┌──────────────────┐      ┌─────────────────────────┐ │
      │             │   │ SRV-RP-NGINX-01  │      │ Réseau App 10.200.0.0/24│ │
      ▼             │   │ 10.199.0.200     │      │                         │ │
  ┌─────────┐       │   │ (DMZ)             │      │  SRV-APP-WP-01          │ │
  │ Pare-feu│───────┼──►│ Nginx Reverse    │─────►│  10.200.0.200           │ │
  │         │       │   │ Proxy            │      │  WordPress (Docker)     │ │
  └─────────┘       │   └──────────────────┘      │                         │ │
                    │                            │  SRV-MONIT-01           │ │
                    │                            │  10.200.0.199           │ │
                    │                            │  Netdata + Patchmon     │ │
                    │                            │                         │ │
                    │                            │  SRV-MASTER-01 (RKE2)   │ │
                    │                            │  10.200.0.201           │ │
                    │                            │                         │ │
                    │                            │  SRV-WORKER-01 (RKE2)   │ │
                    │                            │  10.200.0.202           │ │
                    │                            │                         │ │
                    │                            │  SRV-WORKER-02 (RKE2)   │ │
                    │                            │  10.200.0.203           │ │
                    │                            └─────────────────────────┘ │
                    └─────────────────────────────────────────────────────────┘
```

### 1.3 Inventaire des serveurs

| Serveur | Rôle | IP | RAM | vCPU | Disque |
|---------|------|-----|-----|------|--------|
| SRV-RP-NGINX-01 | Reverse proxy Nginx | 10.199.0.200 | 4 GB | 4 | 30 GB |
| SRV-APP-WP-01 | WordPress (Docker) | 10.200.0.200 | 8 GB | 4 | 30 GB |
| SRV-MONIT-01 | Netdata + Patchmon | 10.200.0.199 | 4 GB | 4 | 30 GB |
| SRV-MASTER-01 | Kubernetes RKE2 Master | 10.200.0.201 | 6 GB | 4 | 30 GB |
| SRV-WORKER-01 | Kubernetes RKE2 Worker | 10.200.0.202 | 4 GB | 2 | 30 GB |
| SRV-WORKER-02 | Kubernetes RKE2 Worker | 10.200.0.203 | 4 GB | 2 | 30 GB |

---

## 2. Prérequis et dépendances

### 2.1 Environnement cible

- **XCP-ng** installé et opérationnel
- **Xen Orchestra (XOA)** déployé et accessible (ex. `ws://10.200.0.10`)
- **Template Rocky Linux 9** préparé avec Cloud-Init (voir `proces/preparation_template_rocky.md`)
- **Réseaux** configurés dans XCP-ng : DMZ (10.199.0.0/24), App (10.200.0.0/24)
- **Storage Repository (SR)** disponible avec espace suffisant

### 2.2 Outils requis sur la station d'administration

| Outil | Version minimale | Usage |
|-------|------------------|-------|
| Terraform | 1.x | Déploiement des VMs |
| Ansible | 2.9+ | Installation RKE2 |
| SSH | - | Accès aux VMs |

---

## 3. Déploiement avec Terraform

### 3.1 Configuration initiale

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Éditer `terraform.tfvars` avec les UUID de votre environnement XOA :

```hcl
affinity_host_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# Optionnel : template_rocky, sr_id, network_dmz_id, network_app_id
```

**Où trouver l'UUID de l'hôte :** XOA → Pools → votre pool → Hosts → clic sur l'hôte → copier l'UUID.

### 3.2 Commandes de déploiement

```bash
terraform init
terraform plan    # Vérifier les changements
terraform apply   # Appliquer (confirmer avec "yes")
```

### 3.3 Variables Terraform

| Variable | Description | Défaut |
|----------|-------------|--------|
| `affinity_host_id` | UUID de l'hôte XCP-ng (obligatoire) | - |
| `template_rocky` | UUID du template Rocky Linux 9 | Défini dans main.tf |
| `sr_id` | UUID du Storage Repository | Défini dans main.tf |
| `network_dmz_id` | UUID du réseau DMZ | Défini dans main.tf |
| `network_app_id` | UUID du réseau applicatif | Défini dans main.tf |

### 3.4 Cloud-Init

Chaque VM reçoit une configuration Cloud-Init incluant :

- Utilisateur `admin-sys` avec clé SSH
- Configuration réseau statique (NetworkManager)
- Installation des paquets (Nginx, Docker, etc.)
- Lancement des services (Docker Compose pour WordPress, Netdata, Patchmon)

---

## 4. Déploiement du cluster Kubernetes (Ansible)

### 4.1 Prérequis

- Les VMs master et workers doivent être **déployées** et **joignables** (réseau, SSH)
- L'inventaire Ansible doit pointer vers les IP correctes

### 4.2 Configuration de l'inventaire

**`ansible_kubernetes/inventory/hosts.ini` :**
```ini
[masters]
kube-master-1

[workers]
kube-worker-1
kube-worker-2
```

**Variables par hôte** (`host_vars/`) : définir `ansible_host` (IP) et `ansible_user` (ex. `admin-sys`).

**Variables chiffrées** (`group_vars/all.yml` avec Ansible Vault) :
```bash
ansible-vault edit inventory/group_vars/all.yml
# Renseigner ansible_become_password si nécessaire
```

### 4.3 Exécution du playbook

```bash
cd ansible_kubernetes
ansible-playbook -i inventory/hosts.ini --ask-vault-pass playbook.yml
```

### 4.4 Rôles Ansible

| Rôle | Cible | Actions |
|------|-------|---------|
| `install_rke2_master` | masters | Installation RKE2 server, démarrage, génération du token |
| `install_rke2_agent` | workers | Installation RKE2 agent, connexion au master via token |

---

## 5. Services applicatifs

### 5.1 WordPress (SRV-APP-WP-01)

- **Accès :** via le reverse proxy (domaine configuré dans Nginx)
- **Stack :** MySQL 5.7 + WordPress (Docker Compose)
- **Répertoire :** `/opt/wordpress/`

### 5.2 Netdata (SRV-MONIT-01)

- **Port :** 19999
- **URL :** `http://10.200.0.199:19999`

### 5.3 Patchmon (SRV-MONIT-01)

- **Port :** 3000
- **Stack :** PostgreSQL 17, Redis 7, backend + frontend
- **URL :** `http://10.200.0.199:3000`

### 5.4 Nginx Reverse Proxy (SRV-RP-NGINX-01)

- **Port :** 80
- **Configuration :** `/etc/nginx/conf.d/reverse.conf`
- Exemple : redirection vers WordPress sur `cours.hostaria.cloud`

---

## 6. Dépannage

### 6.1 Terraform

| Problème | Cause possible | Solution |
|----------|----------------|----------|
| Erreur de connexion XOA | URL/identifiants incorrects | Vérifier `provider "xenorchestra"` dans main.tf |
| Disque vide au boot | Template mal configuré | Vérifier le `name_label` du disque (aligné avec le template) |
| Écran noir au démarrage | Conflit BIOS/UEFI | `hvm_boot_firmware = "uefi"` déjà configuré |
| Validation MAC | Provider strict | Utiliser des MAC fixes (déjà en place) |

### 6.2 Cloud-Init

```bash
# Sur la VM
cloud-init status
cloud-init logs
```

### 6.3 Ansible / RKE2

- Vérifier la connectivité SSH : `ansible -i inventory/hosts.ini all -m ping`
- Vérifier que le token est bien transmis du master aux workers
- Consulter les logs : `journalctl -u rke2-server -f` (master) ou `journalctl -u rke2-agent -f` (worker)

---

## 7. Références

| Document | Emplacement | Contenu |
|----------|-------------|---------|
| Procédure de déploiement | `proces/deploy_process.md` | Bootstrap XOA, Terraform, Ansible |
| Préparation template Rocky | `proces/preparation_template_rocky.md` | Création du template Cloud-Init |
| Journal de bord | `text/journal_de_bord.md` | Historique des décisions techniques |
