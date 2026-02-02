# Proposition Commerciale & Technique : Architecture Multi-Sites (Pessac / Strasbourg)
**Client :** "nova-solar.fr" (100 collaborateurs - 50/site)  
**Projet :** Interconnexion Sites / Sécurisation / PRA  
**Date :** 12 Janvier 2026

---

## Synthèse des besoins (Multi-Sites)
*   **Architecture :** Deux sites distants (Pessac & Strasbourg) à interconnecter (VPN IPsec / SD-WAN).
*   **Volumétrie :** 3 étages de 100m² par site. 50 collaborateurs par site.
*   **Continuité :** Utiliser le site de Strasbourg comme site de secours (PRA) pour Pessac.
*   **Réseau :** Couverture Wifi dense (3 étages) et Switching réparti.

---

## CONNECTIVITÉ TRÈS HAUT DÉBIT (Option Opérateur)
*Offre recommandée : Orange Business ou Bouygues Telecom Entreprises*
*   **Technologie :** Fibre Pro Orange Business (Débit jusqu'à 8 Gb/s).
*   **Sites :** 1 lien pour Pessac + 1 lien pour Strasbourg.
*   **Adresse IP :** IP Fixe incluse (indispensable pour les VPNs).
*   **Coût Estimatif :** **50 € HT / mois / site** (soit 100 € HT / mois total).
*   *Frais de raccordement (FAS) : Offerts sur engagement 36 mois.*

---git

## DÉTAIL DES ACCESSOIRES & ENVIRONNEMENT (Inclus dans les offres)
*Pour garantir une installation professionnelle et pérenne.*

*   **Baies Serveurs :**
    *   **Pessac :** 1x Baie 42U (800x1000) vitrée, ventilée.
    *   **Strasbourg :** 1x Baie 24U (600x1000) pour l'équipement réseau (et serveur en Premium).
*   **Gestion Électrique :**
    *   **Offres 2 & 3 (Serveurs) :** 2x Eaton 3000VA (Rackables) - 1 par site.
    *   **Offre 1 (Réseau seul) :** 2x Eaton Ellipse PRO 850VA - 1 par site.
    *   **PDU :** 4x Bandeaux de prises rackables (2 par baie).
*   **Connectique & Câblage :**
    *   50x Câbles RJ45 Cat6a (0.5m) - Pour le brassage propre des switchs.
    *   20x Câbles RJ45 Cat6a (2m) - Pour les serveurs et uplink.
    *   Modules SFP+ 10G & DAC Cables pour liaison Cœur <-> Serveurs.
    *   Organisateurs de câbles (Passe-câbles balais).

---

## OFFRE 1 : SOCLE RÉSEAU SÉCURISÉ (SD-WAN)
*L'interconnexion sécurisée des deux sites, sans serveurs d'application.*

### Architecture Réseau (x2 Sites)
*   **Cœur de Réseau (Pessac & Strasbourg) :**
    *   2x **FortiGate 80F** (1 par site) configurés en VPN IPsec Site-à-Site (Lien permanent).
*   **Distribution (Par site : 2 en Baie + 3 Étages) :**
    *   10x **FortiSwitch 124F-POE** (5 par site : 2 en Cœur de réseau redondant + 1 par étage).
*   **Wifi 6 (Par site : 3 étages) :**
    *   12x **FortiAP 231F** (6 par site, 2 par étage pour densité/couverture).

### Prestations incluses
*   Configuration SD-WAN / VPN inter-sites.
*   Segmentation VLANs (Voix, Data, Invités) propagée sur les 2 sites.

### Budget Estimatif (Hors Maintenance)
| Poste | Détail | Prix HT |
| :--- | :--- | :--- |
| Matériel Réseau | 2x FortiGate, 10x Switchs, 12x APs | 18 500 € |
| Environnement | Baies, Onduleurs 850VA, Câblage | 2 000 € |
| Licences Sécurité | 2x FortiGate UTP Bundle | 1 800 € /an |
| Main d'œuvre | Déploiement & Config Multi-site (4 jours) | 2 400 € |
| **TOTAL PROJET** | | **22 900 € HT** |
| **COÛT ANNUEL** | *Licences Fortinet* | **1 800 € HT /an** |

---

## OFFRE 2 : STANDARD (CENTRALISÉE PESSAC)
*L'intelligence est centralisée au siège. Strasbourg est connecté en VPN et travaille sur les ressources de Pessac.*

### Architecture Système
*   **Site Pessac (Siège) :**
    *   1x Serveur **HPE ProLiant DL380 Gen11** (Xeon Platinum, 128Go, NVMe) -> Héberge toutes les VMs (ERP, Web, DC).
    *   1x Stockage **TrueNAS** (Full Flash) pour les fichiers et backups locaux.
*   **Site Strasbourg (Agence) :**
    *   Pas de serveur local.
    *   Accès distant aux applications via le tunnel VPN sécurisé (Latence faible grâce à la Fibre).

### Avantages
*   Gestion simplifiée (tout est au même endroit).
*   Coût matériel réduit.

### Budget Estimatif
| Poste | Détail | Prix HT |
| :--- | :--- | :--- |
| Matériel Réseau | Pack Multi-site complet (Offre 1) | 18 500 € |
| Environnement | Baies, Onduleurs, Câblage complet | 3 500 € |
| Licences Sécurité | 2x Gate + 100x FortiClient EDR/ZTNA | 4 500 € /an |
| Serveur Calcul | 1x HPE DL380 Gen11 (Pessac) | 12 500 € |
| Stockage NAS | 1x TrueNAS Flash (Pessac) | 3 200 € |
| Main d'œuvre | Install & Config Centralisée (5 jours) | 3 000 € |
| **TOTAL PROJET** | | **40 700 € HT** |
| **COÛT ANNUEL** | *Licences (100 users)* | **4 500 € HT /an** |
| | *Abonnement Fibre Orange (2 sites)* | **1 200 € HT /an** |

---

## OFFRE 3 : PREMIUM (PRA AUTOMATISÉ) - *Architecture Miroir*
*La continuité totale. Les deux sites sont des miroirs l'un de l'autre. En cas de panne majeure à Pessac, Strasbourg redémarre la prod en quelques minutes.*

### Architecture Haute Dispo
*   **Réseau :** Idem Offre 1 & 2.
*   **Serveurs :** Architecture identique à l'Offre 2 (2x HPE DL380) mais configuration **Cluster Étendu (Disaster Recovery)**.
*   **Stockage :** 2x **TrueNAS Enterprise** (Haute Perf) avec réplication ZFS temps réel.
*   **Mécanisme :**
    *   Les VMs critiques (ERP, Web) tournent à Pessac et sont répliquées toutes les 15min vers Strasbourg.
    *   XOA est configuré pour un **Failover Automatique** (ou en 1 clic).

### Prestations incluses
*   Tests de bascule réels (Coupure lien Pessac -> Démarrage Strasbourg).
*   Documentation PRA complète.

### Budget Estimatif
| Poste | Détail | Prix HT |
| :--- | :--- | :--- |
| Matériel Réseau | Pack Multi-site complet | 14 500 € |
| Licences Sécurité | 2x Gate + 100x FortiClient EDR/ZTNA | 4 500 € /an |
| Serveurs Calcul | 2x HPE DL380 Gen11 (Optimisés PRA) | 25 000 € |
| Stockage Enterprise | 2x TrueNAS Enterprise ZFS Repl. | 9 000 € |
| Main d'œuvre | Config PRA & Tests Bascule (10 jours) | 6 000 € |
| **TOTAL PROJET** | | **63 000 € HT** |
| **COÛT ANNUEL** | *Licences (100 users)* | **4 500 € HT /an** |
| | *Abonnement Fibre Orange (2 sites)* | **1 200 € HT /an** |

---

## INFOGÉRANCE GLOBALE (Multi-Sites)
**Option B (Retenue) : CONTRAT "SÉRÉNITÉ" (Premium 24/7)**
*   Supervision des 2 sites + Tunnels VPN.
*   Support Utilisateur Illimité (100 collaborateurs).
*   Gestion des sauvegardes croisées et tests de restauration annuels.
*   **Tarif mensuel : 1 650 € HT / mois** (Env. 19 800 € / an)
