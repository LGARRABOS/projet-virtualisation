# Pour exécuter le playbook

- Adapter le mot de passe "ansible_host" pour chaque hosts
- Adapter le mot de passe "ansible_become_password" pour chaque hosts
- exécuter la commande :
```
ansible-playbook -i inventory/hosts.ini playbook.yml
```