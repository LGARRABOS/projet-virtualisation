# Journal de Bord - Projet Virtualisation & Infrastructure
**Date :** 13 Janvier 2026
**Sujet :** Conception d'infrastructure et Automatisation (Terraform/XCP-ng)

Ce document résume les étapes franchies aujourd'hui, depuis l'analyse du besoin métier jusqu'à l'implémentation technique fonctionnelle.

---

## 1. Cadrage et Imagination du Scénario ("La Situation")

Pour répondre au sujet MSPR, nous avons défini un contexte client réaliste et précis :

*   **Le Client :** Une PME de 50 collaborateurs dans le secteur photovoltaïque (Bureaux d'études + Techniciens).
*   **Le Contexte :** Déménagement du siège à Pessac et ouverture d'une agence à Strasbourg.
*   **Les Besoins Identifiés :**
    *   **Souveraineté :** Rapatriement des données (ERP Sage, Site Web, Fichiers) en interne ("On-Premise").
    *   **Sécurité :** Protection des accès distants (VPN IPsec entre sites, ZTNA pour le télétravail).
    *   **Disponibilité :** Architecture résiliente avec sauvegarde et redondance.

**Livrables produits sur cette phase :**
*   [`question.md`](./question.md) : Guide d'entretien avec les réponses simulées du client.
*   [`offres_infrastructure.md`](./offres_infrastructure.md) : 3 scénarios chiffrés (Essentiel, Standard, Premium) incluant le matériel (HPE Gen11, Fortinet) et les licences.
*   [`README.md`](./README.md) : Réponse formelle à l'appel d'offres (Executive Summary).

---

## 2. Implémentation Technique (Infrastructure as Code)

L'objectif était d'automatiser le déploiement de la couche applicative sur l'infrastructure virtualisée (XCP-ng) via **Terraform**.

### A. Architecture Cible
Déploiement de 3 Machines Virtuelles (Rocky Linux 9) :
1.  **Reverse Proxy (10.99.0.200) :** Nginx, point d'entrée unique.
2.  **Serveur Applicatif (10.200.0.200) :** WordPress (Docker Compose) répliqué.
3.  **Serveur Monitoring (10.200.0.199) :** Netdata & Patchmon (Docker Compose).

### B. Défis Techniques & Solutions
Nous avons rencontré et résolu plusieurs blocages majeurs lors de la configuration du provider `xenorchestra` :

| Problème Rencontré | Cause Racine | Solution Apportée |
| :--- | :--- | :--- |
| **Disques Vides** | Terraform créait un nouveau disque au lieu de cloner celui du template. | Utilisation de `data "xenorchestra_template"` pour récupérer l'ID et alignement strict du nom/taille du disque (`Rocky Linuaqwf`). |
| **Boot Impossible (Écran Noir)** | Conflit BIOS vs UEFI sur Rocky Linux 9. | Ajout de `hvm_boot_firmware = "uefi"` dans la ressource VM. |
| **Erreurs de Validation MAC** | Le provider ne parvenait pas à valider les MACs dynamiques. | Utilisation de MAC addresses fixes pour la stabilité. |
| **Redirection WordPress** | WordPress s'installait sur l'IP locale (10.x) au lieu du domaine. | Ajout des headers `Host $host` dans Nginx pour transmettre le domaine `cours.hostaria.cloud`. |
| **Accès Web Bloqué** | SELinux et Firewalld bloquaient le port 80 par défaut. | Ajout de commandes Cloud-Init (`setenforce 0`, `firewall-cmd --add-port=80`). |

### C. État Actuel
Le fichier [`main.tf`](./main.tf) est désormais **pleinement fonctionnel**.
*   Il déploie les 3 VMs en parallèle.
*   Il injecte la configuration via **Cloud-Init**.
*   Il installe Docker, configure les réseaux, lance les conteneurs et configure le Reverse Proxy automatiquement.
*   **Résultat :** Le site WordPress est accessible via `http://cours.hostaria.cloud` quelques minutes après le `terraform apply`.

---

## 3. Prochaines Étapes Possibles
*   Finaliser la configuration fine de l'application Patchmon (Base de données, Front).
*   Mettre en place la sauvegarde automatique via XOA (Terraform resource `xenorchestra_backup`).
*   Sécuriser le tout avec HTTPS (Certbot/Let's Encrypt sur le Reverse Proxy).
