# Pour exécuter le playbook

- Adapter le mot de passe "ansible_host" pour chaque hosts
- Adapter le mot de passe "ansible_become_password" dans `group_vars/all.yml` si nécessaire
- exécuter la commande :
```
ansible-playbook -i inventory/hosts.ini --ask-vault-pass playbook.yml
```