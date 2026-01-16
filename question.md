# Questionnaire de Cadrage - Infrastructure Virtualisée
## Contexte : Premier entretien client (PME 20-50 salariés)

### 1. Compréhension du Métier et des Usages (Dimensionnement)
*Objectif : Déterminer la puissance nécessaire (CPU/RAM) et les types d'OS.*

- [ ] **Activité principale :** Quel est votre cœur de métier ? Quels logiciels utilisez-vous au quotidien (ERP, Sage, EBP, Logiciels métier spécifiques) ?
boite de 50 persone qui font du photovoltaique, prohjet de centrale solaire, bcp de technicient et ingé en bureau d'étude. Sage erp, site internet wordpress hébergé chez wix, a héberger a la maison. l'ancine qui s'en occuppe s'en vas, a deleguer a société de presta 
- [ ] **Typologie :** Avez-vous différents profils (ex: Administratif léger vs Bureau d'études gourmand en ressources) ?
Oui pour les accés aux applications specifiques (dossier RH, compta, bureau d'etude etc...)
- [ ] **Mobilité :** Avez-vous besoin d'accès à distance (Télétravail, VPN) ou tout se fait-il au bureau 
Télétravail a 2 jours par semaine. VPN necessaire pour acces au data et les chantiers.
(License forti ou autre firewall) 50 license stable augumentation a X2 dans 5/10 ans. deuxieme site a strasbourg qui ouvre apres le démanégement 
 
### 2. Audit de l'existant (Migration & Compatibilité)
*Objectif : Identifier les risques et le matériel récupérable.*

- [ ] **Dette technique :** Avez-vous des logiciels anciens qui nécessitent absolument une vieille version de Windows ou Linux ?
, NAS a gardé pour les datas 
- [ ] **Stockage des données :** Où sont vos fichiers aujourd'hui ? (Serveur local, NAS, Cloud, dispersés sur les PC ?)
nas local/ serveur de stockage local 
- [ ] **Périphériques :** Avez-vous des imprimantes réseaux, scanners ou automates qui doivent communiquer avec le serveur ?
Grosse imprimante A1 reseau accessible tt le monde 
- [ ] **Matériel actuel :** Dispose-t-on de matériel serveur existant à réutiliser ou part-on de zéro ?
poste fix et poste portable pour les collab, 

### 3. Continuité de Service (RTO / RPO)
*Objectif : Définir la stratégie de sauvegarde et de redémarrage.*

- [ ] **Tolérance à la panne :** Si le serveur plante, combien de temps l'entreprise peut-elle continuer à travailler sans informatique ? (1h, 4h, 1 jour ?)
0 
- [ ] **Perte de données :** En cas de crash, est-il acceptable de perdre le travail de la dernière heure ou de la journée entière ?
Duplication permanente des datas toutes les 30 min 1h 

- [ ] **Maintenance :** Quand pouvons-nous intervenir pour les mises à jour ? (Soir, Week-end ?) nous aussi 
Week end / hors horaire de travail pour mise en des update reboot 

### 4. Sécurité et Administration
*Objectif : Définir l'architecture réseau (VLANs) et les droits.*

- [ ] **Confidentialité :** Avez-vous besoin de cloisonner certains services (ex: La Compta ne doit pas voir les fichiers RH) ?
maintenir les permission actuelle pour les acces aux data.
- [ ] **Gestion interne :** Qui gérera le système au quotidien ? (Besoin d'une interface très simplifiée ?)
On gere leurs systeme et mise a jour /maintenance 24/24 7/7. $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
- [ ] **Connexion Internet :** Avez-vous une fibre dédiée ? Besoin de filtrer l'accès internet des salariés ?
Installation dans les nouveaux locaux de pessac, demande de devis pour la fibre dédiée + ip fix

### 5. Budget et Contraintes
*Objectif : Orienter le choix de l'Hyperviseur (Licences vs Open Source).*

- [ ] **Enveloppe budgétaire :** Avez-vous un budget pour des licences logicielles (VMware, Windows Server) ou privilégiez-vous des solutions gratuites/Open Source (Proxmox, Linux) ?
XCP NG + XOA pour la visu du boss et la simplicité d'interface
$$$$ 
---
*Rappel pour l'entretien : Le client n'est pas technique. Éviter le jargon (VLAN, Hyperviseur, Snapshot) et parler "Usages" et "Besoins".*
``

