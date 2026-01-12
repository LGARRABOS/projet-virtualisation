# Questionnaire de Cadrage - Infrastructure Virtualisée
## Contexte : Premier entretien client (PME 20-50 salariés)

### 1. Compréhension du Métier et des Usages (Dimensionnement)
*Objectif : Déterminer la puissance nécessaire (CPU/RAM) et les types d'OS.*

- [ ] **Activité principale :** Quel est votre cœur de métier ? Quels logiciels utilisez-vous au quotidien (ERP, Sage, EBP, Logiciels métier spécifiques) ?
- [ ] **Volumétrie utilisateurs :** Combien de personnes se connectent en même temps ? (20, 50 ?) Des recrutements prévus ?
- [ ] **Typologie :** Avez-vous différents profils (ex: Administratif léger vs Bureau d'études gourmand en ressources) ?
- [ ] **Mobilité :** Avez-vous besoin d'accès à distance (Télétravail, VPN) ou tout se fait-il au bureau ?

### 2. Audit de l'existant (Migration & Compatibilité)
*Objectif : Identifier les risques et le matériel récupérable.*

- [ ] **Dette technique :** Avez-vous des logiciels anciens qui nécessitent absolument une vieille version de Windows ou Linux ?
- [ ] **Stockage des données :** Où sont vos fichiers aujourd'hui ? (Serveur local, NAS, Cloud, dispersés sur les PC ?)
- [ ] **Périphériques :** Avez-vous des imprimantes réseaux, scanners ou automates qui doivent communiquer avec le serveur ?
- [ ] **Matériel actuel :** Dispose-t-on de matériel serveur existant à réutiliser ou part-on de zéro ?

### 3. Continuité de Service (RTO / RPO)
*Objectif : Définir la stratégie de sauvegarde et de redémarrage.*

- [ ] **Tolérance à la panne :** Si le serveur plante, combien de temps l'entreprise peut-elle continuer à travailler sans informatique ? (1h, 4h, 1 jour ?)
- [ ] **Perte de données :** En cas de crash, est-il acceptable de perdre le travail de la dernière heure ou de la journée entière ?
- [ ] **Maintenance :** Quand pouvons-nous intervenir pour les mises à jour ? (Soir, Week-end ?)

### 4. Sécurité et Administration
*Objectif : Définir l'architecture réseau (VLANs) et les droits.*

- [ ] **Confidentialité :** Avez-vous besoin de cloisonner certains services (ex: La Compta ne doit pas voir les fichiers RH) ?
- [ ] **Gestion interne :** Qui gérera le système au quotidien ? (Besoin d'une interface très simplifiée ?)
- [ ] **Connexion Internet :** Avez-vous une fibre dédiée ? Besoin de filtrer l'accès internet des salariés ?

### 5. Budget et Contraintes
*Objectif : Orienter le choix de l'Hyperviseur (Licences vs Open Source).*

- [ ] **Enveloppe budgétaire :** Avez-vous un budget pour des licences logicielles (VMware, Windows Server) ou privilégiez-vous des solutions gratuites/Open Source (Proxmox, Linux) ?

---
*Rappel pour l'entretien : Le client n'est pas technique. Éviter le jargon (VLAN, Hyperviseur, Snapshot) et parler "Usages" et "Besoins".*
