# Pour exécuter le playbook

- Adapter le hostname "ansible_host" pour chaque hosts afin de pouvoir les joindre
- Adapter le mot de passe "ansible_become_password" dans `group_vars/all.yml` si nécessaire
```
ansible-vault edit inventory/group_vars/all.yml
```
- exécuter le playbook:
```
ansible-playbook -i inventory/hosts.ini --ask-vault-pass playbook.yml
```