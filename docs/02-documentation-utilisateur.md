# Documentation Utilisateur – Accès aux services

**Public cible :** Utilisateurs finaux, collaborateurs de l'entreprise  
**Version :** 1.0  
**Dernière mise à jour :** Mars 2026

---

## 1. Introduction

Ce document vous guide pour accéder aux services informatiques de l'entreprise : site web, monitoring, et outils de gestion des mises à jour. Aucune compétence technique n'est requise.

---

## 2. Accès au site web (WordPress)

### 2.1 Adresse d'accès

Le site web de l'entreprise est accessible à l'adresse configurée par votre administrateur, par exemple :

- **URL :** `http://cours.hostaria.cloud` (ou l'adresse communiquée par votre équipe IT)

### 2.2 Connexion à l'administration WordPress

Si vous êtes administrateur du site :

1. Accédez à l'URL du site
2. Ajoutez `/wp-admin` à la fin de l'adresse (ex. : `http://cours.hostaria.cloud/wp-admin`)
3. Saisissez vos identifiants (login et mot de passe)

### 2.3 En cas de problème

- Vérifiez votre connexion internet
- Vérifiez que vous utilisez la bonne URL
- Contactez votre administrateur ou le support IT en cas d'erreur persistante

---

## 3. Tableau de bord de monitoring (Netdata)

### 3.1 À quoi sert Netdata ?

Netdata affiche en temps réel l'état des serveurs (utilisation processeur, mémoire, disque, réseau). Il est destiné aux administrateurs et aux personnes en charge de la supervision.

### 3.2 Accès

- **URL :** `http://10.200.0.199:19999`
- **Accès :** Réservé au réseau interne de l'entreprise (VPN ou bureau)

### 3.3 Utilisation

- Aucune authentification par défaut
- Les graphiques se mettent à jour automatiquement
- En cas de doute, contactez votre équipe IT

---

## 4. Gestion des mises à jour (Patchmon)

### 4.1 À quoi sert Patchmon ?

Patchmon permet de suivre et gérer les mises à jour de sécurité des postes et serveurs de l'entreprise. Il centralise les informations sur les correctifs à installer.

### 4.2 Accès

- **URL :** `http://10.200.0.199:3000`
- **Accès :** Réservé au réseau interne (VPN ou bureau)

### 4.3 Utilisation

- Connexion avec les identifiants fournis par votre administrateur
- Interface web pour consulter l'état des mises à jour
- Pour toute question, contactez votre équipe IT ou le prestataire en charge de la maintenance

---

## 5. Accès à distance (VPN)

### 5.1 Télétravail

Pour accéder aux services depuis chez vous ou en déplacement :

1. Connectez-vous au **VPN** de l'entreprise (logiciel et identifiants fournis par l'IT)
2. Une fois connecté, vous pouvez accéder au site web, aux fichiers partagés et aux outils internes comme si vous étiez au bureau

### 5.2 En cas de problème de connexion VPN

- Vérifiez votre connexion internet
- Vérifiez que vos identifiants sont corrects
- Redémarrez le logiciel VPN si nécessaire
- Contactez le support IT si le problème persiste

---

## 6. Bonnes pratiques

### 6.1 Sécurité

- Ne partagez jamais vos identifiants
- Déconnectez-vous du VPN lorsque vous n'en avez plus besoin
- Signalez tout comportement inhabituel (messages d'erreur, accès suspects) à votre équipe IT

### 6.2 Sauvegarde

- Les sauvegardes sont gérées par l'administrateur
- En cas de perte de fichier important, contactez rapidement le support

---

## 7. Qui contacter ?

| Besoin | Contact |
|--------|---------|
| Problème d'accès au site web | Équipe IT / Support |
| Problème de connexion VPN | Équipe IT / Support |
| Question sur Netdata ou Patchmon | Administrateur système |
| Maintenance prévue (coupure, mise à jour) | Voir les annonces internes ou demander à l'IT |

---

## 8. Récapitulatif des URLs

| Service | URL | Accès |
|---------|-----|-------|
| Site web | `http://cours.hostaria.cloud` (ou l'URL fournie) | Tout le monde |
| Administration WordPress | `http://cours.hostaria.cloud/wp-admin` | Administrateurs |
| Netdata (monitoring) | `http://10.200.0.199:19999` | Réseau interne |
| Patchmon (mises à jour) | `http://10.200.0.199:3000` | Réseau interne |

*Les adresses exactes peuvent varier selon la configuration de votre entreprise. En cas de doute, consultez votre équipe IT.*
