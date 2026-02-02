# Guide : Préparation Template Rocky Linux 9 pour Cloud-Init

Ce guide détaille toutes les étapes pour créer une VM Template Rocky Linux 9 propre, prête à être clonée par Terraform avec Cloud-Init.

---

## ÉTAPE 1 : Installation de Cloud-Init et Prérequis

```bash
# Mettre à jour le système
dnf update -y

# Installer Cloud-Init et ses dépendances
dnf install -y cloud-init cloud-utils-growpart gdisk

# Installer QEMU Guest Agent (pour XCP-ng)
dnf install -y qemu-guest-agent

# Installer NetworkManager (déjà présent normalement, mais on s'assure)
dnf install -y NetworkManager network-scripts

# Vérifier l'installation
cloud-init --version
```

---

## ÉTAPE 2 : Configuration de Cloud-Init

```bash
# Activer les services Cloud-Init
systemctl enable cloud-init-local cloud-init cloud-config cloud-final

# Activer QEMU Guest Agent
systemctl enable --now qemu-guest-agent

# Vérifier que Cloud-Init détecte bien les datasources (NoCloud pour XCP-ng)
cloud-init status
```

**Note :** Si Cloud-Init ne détecte pas automatiquement la datasource XCP-ng, tu peux forcer la datasource `NoCloud` dans `/etc/cloud/cloud.cfg` :

```bash
# Éditer le fichier de config
vi /etc/cloud/cloud.cfg

# S'assurer que la ligne datasource_list contient "NoCloud" :
# datasource_list: [ NoCloud, ConfigDrive ]
```

---

## ÉTAPE 3 : Nettoyage Complet (Sysprep)

**⚠️ IMPORTANT :** Ces commandes vont effacer toutes les données uniques de la VM. À faire uniquement sur une VM "Master" avant de la convertir en Template.

```bash
# 1. Nettoyer les clés SSH de l'hôte actuel
rm -f /etc/ssh/ssh_host_*

# 2. Nettoyer l'historique shell
history -c
rm -f /root/.bash_history
rm -f /home/*/.bash_history
unset HISTFILE

# 3. Nettoyer les logs système
truncate -s 0 /var/log/messages
truncate -s 0 /var/log/wtmp
truncate -s 0 /var/log/btmp
truncate -s 0 /var/log/audit/audit.log
rm -rf /var/log/*.log
rm -rf /var/log/*.log.*

# 4. Nettoyer la configuration réseau existante (NetworkManager)
rm -f /etc/NetworkManager/system-connections/*.nmconnection

# 5. Réinitialiser le Machine-ID (CRUCIAL pour éviter les conflits)
rm -f /etc/machine-id
touch /etc/machine-id
# Au prochain boot, systemd va régénérer un ID unique

# 6. Nettoyer Cloud-Init (pour qu'il croie que c'est le 1er boot)
cloud-init clean --logs --seed

# 7. Nettoyer le cache DNF
dnf clean all

# 8. Nettoyer les fichiers temporaires
rm -rf /tmp/*
rm -rf /var/tmp/*

# 9. Arrêter proprement la VM
poweroff
```

---

## ÉTAPE 4 : Conversion en Template dans XCP-ng

Une fois la VM éteinte :

1.  Dans **XOA** (Xen Orchestra) ou **XenCenter** :
    *   Clic droit sur la VM -> **"Convert to Template"**.
    *   Donner un nom clair : `Rocky Linux 9 - Cloud-Init Ready`.
2.  Dans ton fichier Terraform (`main.tf`), utiliser ce nom exact :
    ```hcl
    variable "template_rocky" {
      default = "Rocky Linux 9 - Cloud-Init Ready"
    }
    ```

---

## VÉRIFICATION POST-CLONAGE

Quand Terraform aura cloné une nouvelle VM depuis ce template, vérifie que Cloud-Init a bien fonctionné :

```bash
# Se connecter à la nouvelle VM
ssh admin-sys@10.100.0.199

# Vérifier le statut Cloud-Init
cloud-init status

# Voir les logs Cloud-Init
cloud-init logs

# Vérifier que l'IP statique est bien configurée
ip addr show eth0
```

---

## DÉPANNAGE

**Problème :** Cloud-Init ne se lance pas au boot.
```bash
# Vérifier que les services sont bien activés
systemctl status cloud-init-local
systemctl status cloud-init

# Vérifier les logs
journalctl -u cloud-init -f
```

**Problème :** L'IP statique n'est pas appliquée.
```bash
# Vérifier que NetworkManager a bien lu le fichier .nmconnection
nmcli connection show
nmcli connection up eth0
```

**Problème :** Docker ne s'installe pas via Cloud-Init.
```bash
# Vérifier que le repo Docker est bien ajouté
dnf repolist | grep docker
```
