1. inventory file is created automatically by terraform with the public ip of the provisioned host.
2. an environment variable file is also created automatically with the endpoint of the RDS server. This env file
is loaded by the docker container such that the app can access the RDS server.
3. command to deploy the app:
```
ansible-playbook  -i inventory --private-key ../terraform/mykey -u ubuntu ./deploy.yaml
```
