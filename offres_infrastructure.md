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
| Matériel Réseau | Pack Fortinet (Gate, Switchs, APs) | 3 800 € |
| Licence Sécurité | FortiGate UTP Bundle (1 an) | 900 € |
| Main d'œuvre | Installation & Config Réseau (2 jours) | 1 200 € |
| **TOTAL PROJET** | | **5 900 € HT** |

**⚠️ Limites :** Le site WordPress reste chez Wix (pas de serveur pour l'héberger). Le NAS actuel reste un point de défaillance unique (SPOF) et risque d'être lent pour 50 utilisateurs simultanés.

---

## OFFRE 2 : STANDARD (PERFORMANCE & XCP-NG) - *Recommandée*
*L'équilibre idéal. On remplace le stockage vieillissant et on ajoute un serveur de calcul sous XCP-ng pour héberger vos applications métiers et le site web.*

### Architecture Technique
*   **Réseau :** Identique Offre 1 (FortiGate + 2x FortiSwitch + 4x FortiAP).
*   **Serveur Calcul (Hyperviseur) :** 1x Serveur Dell PowerEdge T350 (Intel Xeon E-2300, **256Go RAM**).
    *   OS : **XCP-ng** (Virtualisation).
    *   VMs : Contrôleur de Domaine, Sage ERP, Serveur Web (WordPress), XOA (Gestion).
*   **Sécurité Endpoint :** Agent FortiClient EMS (EDR/ZTNA) déployé sur les 50 postes.
*   **Serveur Stockage :** 1x Serveur dédié **TrueNAS** (ou TrueNAS Mini XL+).
    *   Rôle 1 : Stockage chaud (NFS pour les VMs XCP-ng).
    *   Rôle 2 : Serveur de fichiers (Partages Windows/SMB).
    *   Rôle 3 : Cible de backup local.

### Prestations incluses
*   Migration des données de l'ancien NAS vers TrueNAS.
*   Migration du site Wix vers VM WordPress locale.
*   Mise en place des sauvegardes automatisées (Snapshots horaires).

### Budget Estimatif (Hors Maintenance)
| Poste | Détail | Prix HT |
| :--- | :--- | :--- |
| Matériel Réseau | Pack Fortinet | 3 800 € |
| Licence Sécurité | FortiGate UTP + FortiClient EDR/ZTNA (50 users) | 2 500 € |
| Serveur Calcul | Serveur XCP-ng (Xeon, 256Go RAM) | 3 200 € |
| Serveur Stockage | Serveur TrueNAS + Disques | 1 800 € |
| Main d'œuvre | Install, Migration Data & Web (4 jours) | 2 400 € |
| **TOTAL PROJET** | | **13 700 € HT** |

**✅ Avantages :** Performance accrue, souveraineté des données (Site Web @Home), séparation des rôles (Calcul vs Stockage).

---

## OFFRE 3 : PREMIUM (HAUTE DISPONIBILITÉ)
*Réponse à l'exigence de "0 coupure". Infrastructure redondante pour garantir la continuité d'activité même en cas de panne matérielle d'un serveur.*

### Architecture Technique
*   **Réseau :** Identique Offre 1 & 2.
*   **Sécurité Endpoint :** Identique Offre 2 (FortiClient EDR/ZTNA complet).
*   **Serveurs Calcul :** **2x** Serveurs XCP-ng (Cluster) - **256Go RAM chacun**.
    *   Permet la réplication des VMs. Si le Serveur 1 tombe, le Serveur 2 prend le relais.
*   **Serveur Stockage :** 1x Serveur TrueNAS Enterprise (Double contrôleur ou ZFS Mirroring robuste).
*   **Sauvegarde externe :** Ajout d'un NAS tiers ou Cloud S3 pour externalisation des backups (Règle 3-2-1).

### Prestations incluses
*   Configuration Haute Disponibilité (HA) dans XCP-ng/XOA.
*   Plan de Reprise d'Activité (PRA) : Tests de basculement.
*   Sécurisation avancée (Segmentation fine, IPS/IDS sur FortiGate).

### Budget Estimatif (Hors Maintenance)
| Poste | Détail | Prix HT |
| :--- | :--- | :--- |
| Matériel Réseau | Pack Fortinet | 3 800 € |
| Licence Sécurité | FortiGate UTP + FortiClient EDR/ZTNA (50 users) | 2 500 € |
| Cluster Calcul | 2x Serveurs XCP-ng (256Go RAM) | 6 400 € |
| Stockage & Save | TrueNAS Perf + Backup externe | 2 500 € |
| Main d'œuvre | Config Cluster HA & PRA (6 jours) | 3 600 € |
| **TOTAL PROJET** | | **18 800 € HT** |

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
*   **Tarif mensuel : 450 € HT / mois**

### Option B : CONTRAT "SÉRÉNITÉ" (Premium 24/7)
*La DSI externalisée complète. Idéal pour votre exigence de continuité.*
*   **Tout inclus Option A +**
*   **Maintien en Condition Opérationnelle (MCO) :** Mises à jour proactives et optimisations.
*   **Support Utilisateur :** Helpdesk **ILLIMITÉ** 8h-18h pour les 50 collaborateurs.
*   **Astreinte :** Intervention 24/7 en cas d'arrêt critique de production.
*   **Rapport mensuel :** État du parc, cybersécurité, capacity planning.
*   **Tarif mensuel : 950 € HT / mois**
