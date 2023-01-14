1. inventory file is created automatically by terraform with the public ip of the provisioned host
2. run quick ansible ping:
```
ansible -i inventory --private-key ../terraform/mykey -u ubuntu all -m ping
```
3. playbook to deploy the app:
```
ansible-playbook  -i inventory --private-key ../terraform/mykey -u ubuntu ./deploy.yaml
```