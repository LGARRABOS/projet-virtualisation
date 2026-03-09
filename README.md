# Projet Virtualisation – Infrastructure IT PME

Réponse à une demande de **refonte d'infrastructure IT** pour une PME du secteur photovoltaïque, dans un contexte de déménagement, sécurisation du SI et continuité d'activité.

---

## Vue d'ensemble

Ce dépôt contient :

- **Infrastructure as Code** : Terraform (déploiement VMs sur XCP-ng) et Ansible (cluster Kubernetes RKE2)
- **Documentation** : technique, utilisateur et proposition commerciale
- **Procédures** : déploiement, préparation des templates

### Stack technique

| Composant | Technologie |
|-----------|-------------|
| Virtualisation | XCP-ng, Xen Orchestra (XOA) |
| IaC | Terraform, Ansible |
| OS invités | Rocky Linux 9 |
| Applications | Nginx, WordPress (Docker), Netdata, Patchmon |
| Orchestration | RKE2 (Kubernetes) |

---

## Structure du projet

```
projet-virtualisation/
├── terraform/              # Déploiement des VMs sur XCP-ng
│   ├── main.tf
│   └── terraform.tfvars.example
├── ansible_kubernetes/      # Installation du cluster RKE2
│   ├── playbook.yml
│   └── inventory/
├── docs/                   # Documentation
│   ├── 01-documentation-technique.md
│   ├── 02-documentation-utilisateur.md
│   └── 03-offres-client.md
├── proces/                 # Procédures de déploiement
│   ├── deploy_process.md
│   └── preparation_template_rocky.md
└── text/                   # Documentation métier (archive)
```

---

## Démarrage rapide

### Prérequis

- XCP-ng + Xen Orchestra (XOA) opérationnels
- Template Rocky Linux 9 avec Cloud-Init
- Terraform et Ansible installés

### 1. Déployer les VMs (Terraform)

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Éditer terraform.tfvars (affinity_host_id, etc.)
terraform init
terraform plan
terraform apply
```

### 2. Installer le cluster RKE2 (Ansible)

```bash
cd ansible_kubernetes
ansible-vault edit inventory/group_vars/all.yml  # Configurer ansible_become_password
ansible-playbook -i inventory/hosts.ini --ask-vault-pass playbook.yml
```

---

## Documentation

| Document | Public | Description |
|----------|--------|--------------|
| [Documentation technique](docs/01-documentation-technique.md) | Admins, DevOps | Architecture, Terraform, Ansible, dépannage |
| [Documentation utilisateur](docs/02-documentation-utilisateur.md) | Utilisateurs | Accès aux services (site web, VPN, monitoring) |
| [Offres client](docs/03-offres-client.md) | Direction | Proposition commerciale, coûts, infogérance |

---

## Les trois offres infrastructure

| Offre | Objectif | Budget indicatif |
|-------|----------|------------------|
| **1 – Essentielle** | Virtualisation minimale, pare-feu | ~23 000 € HT |
| **2 – Sécurisée** | IaC, sauvegardes 3-2-1, PRA/PCA | ~41 000 € HT |
| **3 – Avancée** | Multi-sites, failover, résilience | ~63 000 € HT |

*Détails complets dans [docs/03-offres-client.md](docs/03-offres-client.md).*

---

## VMs déployées

| Serveur | Rôle | IP |
|--------|------|-----|
| SRV-RP-NGINX-01 | Reverse proxy Nginx | 10.199.0.200 |
| SRV-APP-WP-01 | WordPress (Docker) | 10.200.0.200 |
| SRV-MONIT-01 | Netdata + Patchmon | 10.200.0.199 |
| SRV-MASTER-01 | Kubernetes RKE2 Master | 10.200.0.201 |
| SRV-WORKER-01/02 | Kubernetes RKE2 Workers | 10.200.0.202 / .203 |

---



