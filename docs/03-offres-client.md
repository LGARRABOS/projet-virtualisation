# Proposition Commerciale – Refonte Infrastructure IT

**Client :** PME secteur photovoltaïque  
**Contexte :** Déménagement, sécurisation du système d'information, continuité d'activité  
**Date :** Mars 2026

---

## Votre situation

Votre entreprise connaît une **croissance rapide** et doit faire face à plusieurs enjeux :

- Augmentation du nombre d'utilisateurs et de services
- Infrastructure actuelle peu virtualisée et peu sécurisée
- Manque de segmentation réseau
- Sauvegardes insuffisamment maîtrisées
- Exposition aux risques cyber
- Besoin de **continuité de service** lors du déménagement

**Votre objectif :** une solution **fiable**, **sécurisée**, **évolutive** et **financièrement maîtrisée**.

---

## Notre approche

Plutôt que de proposer une solution unique, nous avons structuré notre réponse en **trois offres** adaptées à vos priorités et à votre budget :


| Offre                                  | Objectif                                     | Pour qui ?                                      |
| -------------------------------------- | -------------------------------------------- | ----------------------------------------------- |
| **Offre 1 – Essentielle**              | Répondre au besoin minimal de virtualisation | Budget contraint, première étape                |
| **Offre 2 – Sécurisée et automatisée** | Infrastructure fiable et maintenable         | PME en croissance, professionnalisation du SI   |
| **Offre 3 – Avancée et résiliente**    | Haute disponibilité et résilience            | Données sensibles, exigence forte de continuité |


---

## Offre 1 – Infrastructure Essentielle

### En bref

Une **première étape** vers la virtualisation et la centralisation de vos services, sans investissement matériel lourd (hors pare-feu).

### Ce qui est inclus


| Élément        | Détail                                                        |
| -------------- | ------------------------------------------------------------- |
| Virtualisation | XCP-ng (solution open source, sans licence)                   |
| Réseau         | Segmentation par VLAN, pare-feu dédié avec règles de sécurité |
| Hébergement    | Centralisation des machines virtuelles                        |
| Sauvegardes    | Basiques                                                      |
| Administration | Principalement manuelle                                       |


### Avantages

- Budget maîtrisé
- Mise en place rapide
- Base solide pour évoluer vers les offres 2 ou 3

### À qui s'adresse cette offre ?

- Entreprises avec un **budget limité**
- Première expérience de virtualisation
- Pas d'achat de matériel physique supplémentaire (hors pare-feu)

---

## Offre 2 – Infrastructure Sécurisée et Automatisée

### En bref

Une infrastructure **fiable**, **sécurisée** et **maintenable**, avec déploiement automatisé et plan de continuité.

### Ce qui est inclus


| Élément        | Détail                                              |
| -------------- | --------------------------------------------------- |
| Virtualisation | XCP-ng complet                                      |
| Réseau         | Segmentation par VLAN, pare-feu dédié               |
| Sauvegardes    | Règle 3-2-1 (3 copies, 2 supports, 1 hors site)     |
| Automatisation | Déploiement via Terraform + Cloud-Init + Ansible    |
| Continuité     | PRA / PCA (Plan de Reprise / Continuité d'Activité) |
| Matériel       | Serveurs, stockage et pare-feu adaptés              |


### Avantages

- Gestion simplifiée grâce à l'automatisation
- Sauvegardes structurées et testées
- Documentation et procédures de reprise

### À qui s'adresse cette offre ?

- PME en **croissance**
- Volonté de **professionnaliser** le système d'information
- Besoin de traçabilité et de reproductibilité

---

## Offre 3 – Infrastructure Avancée et Résiliente

### En bref

Un **haut niveau de disponibilité**, de **sécurité** et de **résilience**, avec redondance sur plusieurs sites.

### Ce qui est inclus


| Élément        | Détail                                                       |
| -------------- | ------------------------------------------------------------ |
| Virtualisation | Redondante sur les deux sites (ex. Pessac + Strasbourg)      |
| Réseau         | Segmentation stricte, interconnexion sécurisée (VPN, SD-WAN) |
| Sauvegardes    | Avancées + tests de restauration réguliers                   |
| Continuité     | PRA / PCA avec failover possible                             |
| Supervision    | Traçabilité et monitoring renforcés                          |
| Matériel       | Serveurs et stockage redondés                                |


### Avantages

- En cas de panne majeure sur un site, le second prend le relais
- Données et services protégés
- Conformité renforcée pour les données sensibles

### À qui s'adresse cette offre ?

- Données **sensibles**
- Exigence forte de **continuité de service**
- Deux sites ou plus à interconnecter

---

## Comparatif synthétique


| Critère                | Offre 1 | Offre 2 | Offre 3 |
| ---------------------- | ------- | ------- | ------- |
| Virtualisation         | ✔       | ✔       | ✔✔      |
| Segmentation réseau    | ✔       | ✔       | ✔✔      |
| Sécurité               | ✔       | ✔       | ✔✔      |
| Sauvegarde 3-2-1       | ❌       | ✔       | ✔✔      |
| Automatisation (IaC)   | ❌       | ✔       | ✔✔      |
| PRA / PCA              | ❌       | ✔       | ✔✔      |
| Évolutivité long terme | ⚠       | ✔       | ✔✔      |


*✔✔ = niveau renforcé | ✔ = inclus | ⚠ = limité | ❌ = non inclus*

---

## Détail des coûts par offre

*Les montants ci-dessous sont indicatifs et dépendent du matériel choisi et de votre configuration exacte. Exemple basé sur une architecture multi-sites (Pessac + Strasbourg, 100 collaborateurs).*

---

### Connectivité (option opérateur)

*Recommandé : Orange Business ou Bouygues Telecom Entreprises*


| Élément                     | Détail                            | Coût                                  |
| --------------------------- | --------------------------------- | ------------------------------------- |
| Technologie                 | Fibre Pro (jusqu'à 8 Gb/s)        | 50 € HT / mois / site                 |
| Sites                       | 1 lien Pessac + 1 lien Strasbourg | **100 € HT / mois** (1 200 € HT / an) |
| Adresse IP                  | IP fixe incluse                   | Inclus                                |
| Frais de raccordement (FAS) | Offerts sur engagement 36 mois    | -                                     |


---

### Accessoires et environnement (inclus dans les offres)


| Poste          | Offre 1                                 | Offres 2 & 3                |
| -------------- | --------------------------------------- | --------------------------- |
| Baies serveurs | Pessac : 42U ; Strasbourg : 24U         | Idem                        |
| Onduleurs      | 2x Eaton Ellipse PRO 850VA              | 2x Eaton 3000VA (rackables) |
| PDU            | 4x bandeaux de prises rackables         | Idem                        |
| Câblage        | RJ45 Cat6a, SFP+ 10G, DAC, passe-câbles | Idem                        |


---

### Offre 1 – Socle réseau sécurisé (SD-WAN)

**Architecture :** Interconnexion des deux sites sans serveurs d'application.


| Poste                     | Détail                                                                 | Prix HT             |
| ------------------------- | ---------------------------------------------------------------------- | ------------------- |
| Matériel réseau           | 2x FortiGate 80F, 10x FortiSwitch 124F-POE, 12x FortiAP 231F (Wi-Fi 6) | 18 500 €            |
| Environnement             | Baies, onduleurs 850VA, câblage                                        | 2 000 €             |
| Licences sécurité         | 2x FortiGate UTP Bundle                                                | 1 800 € / an        |
| Main d'œuvre              | Déploiement et configuration multi-site (4 jours)                      | 2 400 €             |
| **TOTAL PROJET**          |                                                                        | **22 900 € HT**     |
| **COÛT ANNUEL RÉCURRENT** | Licences Fortinet                                                      | **1 800 € HT / an** |


---

### Offre 2 – Standard (centralisée Pessac)

**Architecture :** Tout centralisé au siège. Strasbourg connecté en VPN.


| Poste                     | Détail                                                    | Prix HT             |
| ------------------------- | --------------------------------------------------------- | ------------------- |
| Matériel réseau           | Pack multi-site complet (Offre 1)                         | 18 500 €            |
| Environnement             | Baies, onduleurs 3000VA, câblage complet                  | 3 500 €             |
| Licences sécurité         | 2x FortiGate + 100x FortiClient EDR/ZTNA                  | 4 500 € / an        |
| Serveur calcul            | 1x HPE ProLiant DL380 Gen11 (Xeon Platinum, 128 Go, NVMe) | 12 500 €            |
| Stockage NAS              | 1x TrueNAS Full Flash (Pessac)                            | 3 200 €             |
| Main d'œuvre              | Installation et configuration centralisée (5 jours)       | 3 000 €             |
| **TOTAL PROJET**          |                                                           | **40 700 € HT**     |
| **COÛT ANNUEL RÉCURRENT** | Licences (100 utilisateurs)                               | **4 500 € HT / an** |
|                           | Abonnement Fibre Orange (2 sites)                         | **1 200 € HT / an** |
|                           | **TOTAL ANNUEL**                                          | **5 700 € HT / an** |


---

### Offre 3 – Premium (PRA automatisé)

**Architecture :** Miroir entre les deux sites. Failover en cas de panne majeure.


| Poste                     | Détail                                             | Prix HT             |
| ------------------------- | -------------------------------------------------- | ------------------- |
| Matériel réseau           | Pack multi-site complet                            | 14 500 €            |
| Licences sécurité         | 2x FortiGate + 100x FortiClient EDR/ZTNA           | 4 500 € / an        |
| Serveurs calcul           | 2x HPE ProLiant DL380 Gen11 (optimisés PRA)        | 25 000 €            |
| Stockage enterprise       | 2x TrueNAS Enterprise (réplication ZFS temps réel) | 9 000 €             |
| Main d'œuvre              | Configuration PRA et tests de bascule (10 jours)   | 6 000 €             |
| **TOTAL PROJET**          |                                                    | **63 000 € HT**     |
| **COÛT ANNUEL RÉCURRENT** | Licences (100 utilisateurs)                        | **4 500 € HT / an** |
|                           | Abonnement Fibre Orange (2 sites)                  | **1 200 € HT / an** |
|                           | **TOTAL ANNUEL**                                   | **5 700 € HT / an** |


*Prestations incluses Offre 3 :* tests de bascule réels, documentation PRA complète.

---

### Récapitulatif des investissements


|                                            | Offre 1     | Offre 2     | Offre 3     |
| ------------------------------------------ | ----------- | ----------- | ----------- |
| **Investissement initial**                 | 22 900 € HT | 40 700 € HT | 63 000 € HT |
| **Coût annuel (licences + fibre)**         | 1 800 € HT  | 5 700 € HT  | 5 700 € HT  |
| **Sur 3 ans (investissement + récurrent)** | 28 300 € HT | 57 800 € HT | 80 100 € HT |


---

## Offres d'infogérance

**Périmètre :** L'infogérance couvre **uniquement les solutions que nous installons** (serveurs, virtualisation, stockage, pare-feu, VPN, applications hébergées). Elle ne comprend **pas** la gestion des postes utilisateurs (PC, ordinateurs portables).

---

### Infogérance 1 – Essentielle

**Pour qui ?** Entreprises souhaitant externaliser la maintenance de base de l'infrastructure déployée.

| Prestation | Détail |
|------------|--------|
| Périmètre | Serveurs, VMs, stockage, pare-feu, VPN – solutions installées uniquement |
| Horaires | Lundi–Vendredi, 9h–18h |
| Support | Par ticket (délai de réponse : 4h ouvrées) |
| Supervision | Surveillance des alertes critiques sur l'infrastructure |
| Maintenance | Mises à jour planifiées (soir/week-end) |
| Sauvegardes | Vérification hebdomadaire |
| Rapport | Bilan mensuel d'activité |

| Tarif | Montant |
|-------|---------|
| Mensuel | **650 € HT / mois** |
| Annuel | **7 800 € HT / an** |

*Sur la base de l'infrastructure déployée (Offre 1 ou équivalent). Extension : sur devis.*

---

### Infogérance 2 – Standard

**Pour qui ?** PME ayant besoin d'un support réactif et d'une supervision proactive sur l'infrastructure.

| Prestation | Détail |
|------------|--------|
| Périmètre | Serveurs, VMs, stockage, pare-feu, VPN – solutions installées uniquement |
| Horaires | Lundi–Vendredi, 8h–19h + astreinte samedi matin |
| Support | Illimité par ticket et téléphone (délai : 2h ouvrées) |
| Supervision | Monitoring 24/7 des sites et tunnels VPN |
| Maintenance | Mises à jour + interventions préventives |
| Sauvegardes | Gestion quotidienne, vérification hebdomadaire |
| PRA/PCA | Participation aux tests de bascule (1x / an) |
| Rapport | Bilan mensuel détaillé + réunion trimestrielle |

| Tarif | Montant |
|-------|---------|
| Mensuel | **1 100 € HT / mois** |
| Annuel | **13 200 € HT / an** |

*Sur la base de l'infrastructure déployée (Offre 2 ou équivalent). Extension : sur devis.*

---

### Infogérance 3 – Sérénité (Premium 24/7)

**Pour qui ?** Entreprises exigeant une continuité totale sur l'infrastructure déployée.

| Prestation | Détail |
|------------|--------|
| Périmètre | Serveurs, VMs, stockage, pare-feu, VPN, réplication – solutions installées uniquement |
| Horaires | **24h/24, 7j/7** |
| Support | Illimité (ticket, téléphone, chat) – délai : 1h |
| Supervision | 24/7 des sites, tunnels VPN, réplication |
| Maintenance | Mises à jour + interventions préventives + optimisation |
| Sauvegardes | Gestion des sauvegardes croisées, tests de restauration annuels |
| PRA/PCA | Tests de bascule réels, documentation à jour |
| Rapport | Bilan mensuel + réunion mensuelle + SLA garanti |

| Tarif | Montant |
|-------|---------|
| Mensuel | **1 650 € HT / mois** |
| Annuel | **19 800 € HT / an** |

*Sur la base de l'infrastructure déployée (Offre 3 ou équivalent). Extension : sur devis.*

---

### Comparatif des offres d'infogérance

| Critère | Essentielle | Standard | Sérénité |
|---------|:-----------:|:--------:|:--------:|
| Support 24/7 | ❌ | ❌ | ✔ |
| Délai de réponse | 4h | 2h | 1h |
| Supervision continue | ❌ | ✔ | ✔ |
| Gestion sauvegardes | Vérification | Quotidienne | Croisée + tests |
| Tests PRA/PCA | ❌ | 1x / an | Complets |
| Réunion client | - | Trimestrielle | Mensuelle |
| SLA garanti | ❌ | ❌ | ✔ |

| Tarif mensuel | 650 € HT | 1 100 € HT | 1 650 € HT |
| Tarif annuel | 7 800 € HT | 13 200 € HT | 19 800 € HT |

---

### Compatibilité avec les offres infrastructure

| Infrastructure | Infogérance recommandée |
|----------------|-------------------------|
| Offre 1 (Essentielle) | Infogérance 1 ou 2 |
| Offre 2 (Standard) | Infogérance 2 ou 3 |
| Offre 3 (Premium) | Infogérance 3 (Sérénité) |

*L'infogérance peut être souscrite en complément de l'une des offres infrastructure. Elle porte uniquement sur les équipements et logiciels que nous déployons, et non sur les postes utilisateurs.*

---

## Prochaines étapes

1. **Échange** : Nous convenons d’un rendez-vous pour préciser vos besoins et votre budget.
2. **Devis sur mesure** : Nous adaptons l’une des offres à votre situation.
3. **Planification** : Nous définissons ensemble le calendrier de déploiement.

---

*Document de proposition commerciale – Les prix et configurations sont indicatifs et peuvent être ajustés selon votre contexte.*