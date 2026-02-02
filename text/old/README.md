# Réponse à Appel d'Offres : Refonte Infrastructure IT

**Référence Projet :** INFRA-PME-2026-V1  
**Date :** 12 Janvier 2026  
**Destinataire :** Direction Générale - PME Photovoltaïque  
**Objet :** Proposition technique et financière suite à notre entretien de cadrage.

---

## 1. Contexte et Enjeux
Suite à notre entretien du 12 Janvier, nous avons bien pris en compte vos défis actuels liés à votre déménagement sur Pessac et à la croissance de vos effectifs (50 collaborateurs à ce jour, projection x2).

**Vos enjeux majeurs identifiés :**
*   **Sécurisation :** Protection des accès distants (Télétravail) et isolation du réseau.
*   **Souveraineté :** Volonté de rapatrier vos données (Site Web, ERP) en interne ("On Premise").
*   **Continuité :** Exigence forte de disponibilité (RTO proche de 0) et de sauvegarde.
*   **Simplicité :** Délégation totale de la gestion technique (Infogérance).

## 2. Notre Réponse : L'Offre "Standard Performance"
Après analyse, nous écartons l'offre "Basse" (trop risquée pour 50 utilisateurs) et l'offre "Premium" (surdimensionnée à ce stade). Nous préconisons l'offre **Standard**, qui offre le meilleur équilibre Investissement / Performance.

### Architecture Proposée
Nous avons conçu une architecture moderne, évolutive et résiliente :

1.  **Cœur de Calcul Puissant :**
    *   Serveur **HPE ProLiant DL380 Gen11** (Intel Xeon Platinum, 128 Go RAM).
    *   Virtualisation sous **XCP-ng** (Open Source, robuste).
    *   Stockage Full NVMe pour une réactivité immédiate de l'ERP Sage.

2.  **Sécurité de bout en bout (Fortinet Security Fabric) :**
    *   Pare-feu **FortiGate 80F** pour filtrer l'entrée.
    *   Protection des postes avec **FortiClient EMS** (EDR + ZTNA) pour sécuriser le télétravail.
    *   Segmentation réseau (VLANs) pour isoler la Compta, la Technique et le Wi-Fi invités.

3.  **Stockage & Sauvegarde Dédiés :**
    *   Serveur **TrueNAS** dédié au stockage froid et aux backups.
    *   Politique de sauvegarde "3-2-1" incluse.

## 3. Automatisation et Industrialisation
Afin de garantir un déploiement rapide et sans erreur humaine, nous utilisons les technologies "Infrastructure as Code" (IaC) :
*   **Terraform :** Pour le déploiement automatisé des machines virtuelles.
*   **Cloud-Init :** Pour la configuration automatique des serveurs (Monitoring Netdata, Serveur Web LAMP).

*Voir le fichier [deploy_process.md](./deploy_process.md) pour les détails techniques.*

## 4. Budget Synthétique
*   **Investissement Matériel & Logiciel (CAPEX) :** ~23 600 € HT
*   **Services Récurrents (Infogérance 24/7) :** 950 € HT / mois

*Le détail complet est disponible dans le document [offres_infrastructure.md](./offres_infrastructure.md).*

---

**Nous restons à votre disposition pour une démonstration technique de la solution XCP-ng / XOA.**

*L'équipe Infrastructure*
