# Projet Virtualisation – Réponse à la demande INFRA-PME-2026

Ce dépôt présente la **réponse apportée à une demande de refonte d’infrastructure IT** pour une PME en croissance, dans un contexte de **déménagement**, de **sécurisation du SI** et de **continuité d’activité**.

La réponse s’articule autour de **trois offres distinctes**, permettant à la direction de choisir une solution adaptée à ses **contraintes budgétaires**, à son **niveau de maturité IT** et à ses **objectifs de sécurité**.

---

## 1. Contexte et problématique

L’entreprise concernée est une **PME du secteur photovoltaïque**, confrontée à plusieurs enjeux :

- Croissance rapide de l’activité
- Augmentation du nombre d’utilisateurs et de services
- Infrastructure existante peu virtualisée
- Manque de segmentation réseau
- Sauvegardes insuffisamment maîtrisées
- Exposition aux risques cyber
- Besoin de continuité de service lors du déménagement

👉 La direction souhaite une solution :
- fiable
- sécurisée
- évolutive
- financièrement maîtrisée

---

## 2. Démarche de réponse

Plutôt que de proposer une solution unique, le choix a été fait de **structurer la réponse en trois offres** :

- une offre **essentielle** pour répondre aux besoins immédiats,
- une offre **équilibrée** apportant sécurité et automatisation,
- une offre **avancée** orientée résilience, sécurité renforcée et pérennité.

Cette approche permet une **prise de décision éclairée**, en fonction des priorités de l’entreprise.

---

## 3. Les trois offres proposées

### 🔹 Offre 1 – Infrastructure Essentielle

**Objectif :** répondre au besoin minimal de virtualisation et de centralisation.

Principales caractéristiques :
- Virtualisation complète (XCP-ng)
- Segmentation réseau par VLAN
- Hébergement centralisé des machines virtuelles
- Pare-feu dédié avec règles de sécurité
- Sauvegardes basiques
- Administration principalement manuelle

👉 Offre adaptée à :
- un budget contraint
- une première étape vers la virtualisation
- Pas d'achat de matériel physique supplémentaire (hors firewall)

---

### 🔹 Offre 2 – Infrastructure Sécurisée et Automatisée

**Objectif :** proposer une infrastructure fiable, sécurisée et maintenable.

Principales caractéristiques :
- Virtualisation complète (XCP-ng)
- Segmentation réseau par VLAN
- Pare-feu dédié avec règles de sécurité
- Sauvegardes structurées (règle 3-2-1)
- Déploiement automatisé via **Terraform + Cloud-Init**
- PRA / PCA
- Achat de matériel adapté (serveurs, stockage, firewall)

👉 Offre adaptée à :
- une PME en croissance
- une volonté de professionnalisation du SI

---

### 🔹 Offre 3 – Infrastructure Avancée et Résiliente

**Objectif :** garantir un haut niveau de disponibilité, de sécurité et de résilience.

Principales caractéristiques :
- Virtualisation redondante sur les deux sites
- Segmentation réseau stricte
- Sauvegardes avancées + tests de restauration
- PRA / PCA
- Supervision et traçabilité accrues
- Achat de matériel redonder (serveurs, stockage, firewall)

👉 Offre adaptée à :
- des données sensibles
- une exigence forte de continuité de service

---

## 4. Comparaison synthétique des offres

| Critère                     | Offre 1 | Offre 2 | Offre 3 |
|----------------------------|---------|---------|---------|
| Virtualisation             | ✔️      | ✔️      | ✔️✔️ |
| Segmentation réseau        | ✔️      | ✔️      | ✔️✔️ |
| Sécurité                   | ✔️      | ✔️      | ✔️✔️ |
| Sauvegarde 3-2-1           | ❌      | ✔️      | ✔️✔️ |
| Automatisation (IaC)       | ❌      | ✔️      | ✔️✔️ |
| PRA / PCA                  | ❌      | ✔️      | ✔️✔️ |
| Évolutivité long terme     | ⚠️      | ✔️      | ✔️✔️ |

---