# Proposition Commerciale & Technique : Refonte Infrastructure IT
**Client :** PME Photovoltaïque (50 collaborateurs - Projection 100)  
**Projet :** Déménagement (Pessac) / Sécurisation / Internalisation  
**Date :** 12 Janvier 2026

---

## Synthèse des besoins
*   **Réseau & Sécurité :** Gestion de 50 utilisateurs + Télétravail (VPN SSL), couverture WiFi des nouveaux locaux, isolation des flux (VLANs).
*   **Hébergement :** Internalisation du site web (WordPress), ERP Sage, Serveur de fichiers.
*   **Disponibilité :** Exigence forte (RTO proche de 0), sauvegardes fréquentes (toutes les 30min/1h).
*   **Administration :** Délégation totale (Infogérance 24/7).

---

## OFFRE 1 : L'ESSENTIEL (SÉCURITÉ RÉSEAU)
*Cette offre se concentre uniquement sur la sécurisation des accès et du réseau, en conservant le stockage actuel (NAS) pour limiter l'investissement initial.*

### Architecture Technique
*   **Pare-feu :** 1x Fortinet **FortiGate 80F** (Dimensionné pour 50-80 utilisateurs + VPN).
*   **Commutation :** 2x **FortiSwitch 124F-POE** (48 ports total, POE pour les bornes et téléphones).
*   **WiFi :** 4x Bornes **FortiAP 231F** (Wifi 6, gérées par le FortiGate).
*   **Stockage :** Maintien du NAS existant (Nettoyage et sécurisation des accès).

### Prestations incluses
*   Installation et rackage du matériel réseau.
*   Configuration des VLANs (Admin, Staff, Invités).
*   Configuration VPN SSL (FortiClient) pour le télétravail.

### Budget Estimatif (Hors Maintenance)
| Poste | Détail | Prix HT |
| :--- | :--- | :--- |
| Matériel Réseau | Pack Fortinet (Gate, 2x Switchs, 4x APs) | 5 500 € |
| Licence Sécurité | FortiGate UTP Bundle | 900 € /an |
| Main d'œuvre | Installation & Config Réseau (2 jours) | 1 200 € |
| **TOTAL PROJET (Investissement)** | | **6 700 € HT** |
| **COÛT ANNUEL (Récurrent)** | *Renouvellement Licences* | **900 € HT /an** |

**⚠️ Limites :** Le site WordPress reste chez Wix (pas de serveur pour l'héberger). Le NAS actuel reste un point de défaillance unique (SPOF) et risque d'être lent pour 50 utilisateurs simultanés.

---

## OFFRE 2 : STANDARD (PERFORMANCE & XCP-NG) - *Recommandée*
*L'équilibre idéal. On remplace le stockage vieillissant et on ajoute un serveur de calcul sous XCP-ng pour héberger vos applications métiers et le site web.*

### Architecture Technique
*   **Réseau :** Identique Offre 1 (FortiGate + 2x FortiSwitch + 4x FortiAP).
*   **Serveur Calcul (Hyperviseur) :** 1x Serveur **HPE ProLiant DL380 Gen11** (Intel Xeon Platinum 84xx, **128Go RAM DDR5**, **Stockage Full NVMe**).
    *   **Stockage Local :** 2x SSD NVMe 1.92TB Mixed Use (RAID 1) - Capacité utile : ~1.8TB.
    *   OS : **XCP-ng** (Virtualisation).
    *   VMs : Contrôleur de Domaine, Sage ERP, Serveur Web (WordPress), XOA (Gestion).
*   **Sécurité Endpoint :** Agent FortiClient EMS (EDR/ZTNA) déployé sur les 50 postes.
*   **Serveur Stockage :** 1x Serveur dédié **TrueNAS** (Full Flash SSD).
    *   **Disques :** 4x SSD SATA 4TB (RAIDZ1) - Capacité utile : ~11TB.
    *   Rôle 1 : Cible de backup (NFS) haute performance.
    *   Rôle 2 : Serveur de fichiers (Partages Windows/SMB).

### Prestations incluses
*   Migration des données de l'ancien NAS vers TrueNAS.
*   Migration du site Wix vers VM WordPress locale.
*   **Domaine :** Achat et gestion du domaine **`nova-solar.fr`** (via Cloudflare).
*   Mise en place des sauvegardes automatisées (Snapshots horaires).

### Budget Estimatif (Hors Maintenance)
| Poste | Détail | Prix HT |
| :--- | :--- | :--- |
| Matériel Réseau | Pack Fortinet (Gate, 2x Switchs, 4x APs) | 5 500 € |
| Licence Sécurité | FortiGate UTP + FortiClient EDR/ZTNA (50 users) | 2 500 € /an |
| Nom de Domaine | nova-solar.fr (Cloudflare) | 15 € /an |
| Serveur Calcul | HPE DL380 Gen11 (Xeon Platinum, 128Go, NVMe) | 12 500 € |
| Serveur Stockage | Serveur TrueNAS (Full Flash SSD) | 3 200 € |
| Main d'œuvre | Install, Migration Data & Web (4 jours) | 2 400 € |
| **TOTAL PROJET (Investissement)** | | **23 600 € HT** |
| **COÛT ANNUEL (Récurrent)** | *Licences + Domaine* | **2 515 € HT /an** |

**✅ Avantages :** Performance accrue, souveraineté des données (Site Web @Home), séparation des rôles (Calcul vs Stockage).

---

## OFFRE 3 : PREMIUM (HAUTE DISPONIBILITÉ)
*Réponse à l'exigence de "0 coupure". Infrastructure redondante pour garantir la continuité d'activité même en cas de panne matérielle d'un serveur.*

### Architecture Technique
*   **Réseau :** Identique Offre 1 & 2.
*   **Sécurité Endpoint :** Identique Offre 2 (FortiClient EDR/ZTNA complet).
*   **Serveurs Calcul :** **2x** Serveurs **HPE DL380 Gen11** (Cluster) - **Xeon Platinum**, **128Go RAM**, **Full NVMe**.
    *   **Stockage par nœud :** 2x SSD NVMe 1.92TB (RAID 1).
    *   Permet la réplication des VMs. Si le Serveur 1 tombe, le Serveur 2 prend le relais.
*   **Serveur Stockage :** 1x Serveur TrueNAS Enterprise (Double contrôleur ou ZFS Mirroring robuste).
    *   **Disques :** 6x SSD SATA 4TB (RAIDZ2 - Double parité) - Capacité utile : ~15TB.
*   **Sauvegarde externe :** Ajout d'un NAS tiers ou Cloud S3 pour externalisation des backups (Règle 3-2-1).

### Prestations incluses
*   Configuration Haute Disponibilité (HA) dans XCP-ng/XOA.
*   Plan de Reprise d'Activité (PRA) : Tests de basculement.
*   Sécurisation avancée (Segmentation fine, IPS/IDS sur FortiGate).

### Budget Estimatif (Hors Maintenance)
| Poste | Détail | Prix HT |
| :--- | :--- | :--- |
| Matériel Réseau | Pack Fortinet (Gate, 2x Switchs, 4x APs) | 5 500 € |
| Licence Sécurité | FortiGate UTP + FortiClient EDR/ZTNA (50 users) | 2 500 € /an |
| Nom de Domaine | nova-solar.fr (Cloudflare) | 15 € /an |
| Cluster Calcul | 2x HPE DL380 Gen11 (Xeon Platinum) | 25 000 € |
| Stockage & Save | TrueNAS Enterprise (Full Flash) + Backup ext | 4 500 € |
| Main d'œuvre | Config Cluster HA & PRA (6 jours) | 3 600 € |
| **TOTAL PROJET (Investissement)** | | **38 600 € HT** |
| **COÛT ANNUEL (Récurrent)** | *Licences + Domaine* | **2 515 € HT /an** |

**✅ Avantages :** Résilience maximale, maintenance sans interruption de service (migration des VMs à chaud).

---

## OPTIONS DE MAINTENANCE (INFOGÉRANCE)

### Option A : CONTRAT "ESSENTIEL" (Standard)
*Pour une gestion proactive de l'infrastructure, sans le support utilisateur illimité.*
*   **Supervision :** Monitoring des liens et serveurs (Alerte si panne).
*   **Astreinte :** Intervention 24/7 en cas d'arrêt critique de production.
*   **Mises à jour :** Patchs de sécurité critiques (Firewall & Serveurs) 1x/mois.
*   **Sauvegardes :** Vérification quotidienne des rapports de backup.
*   **Support :** 
    *   Intervention sur panne infrastructure : Incluse (J+1).
    *   Support utilisateur : Facturé au ticket ou pack d'heures.
*   **Tarif mensuel : 450 € HT / mois** (5 400€ HT annuel)

### Option B : CONTRAT "SÉRÉNITÉ" (Premium 24/7)
*La DSI externalisée complète. Idéal pour votre exigence de continuité.*
*   **Tout inclus Option A +**
*   **Maintien en Condition Opérationnelle (MCO) :** Mises à jour proactives et optimisations.
*   **Support Utilisateur :** Helpdesk **ILLIMITÉ** 8h-18h pour les 50 collaborateurs.
*   **Astreinte :** Intervention 24/7 en cas d'arrêt critique de production.
*   **Rapport mensuel :** État du parc, cybersécurité, capacity planning.
*   **Tarif mensuel : 950 € HT / mois** (/11 500€ HT annuel)
