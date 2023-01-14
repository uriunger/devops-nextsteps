# First steps:
1. added maven build that generates a war
2. wrap maven in docker - the Dockerfile build the webapp and creates a deployable image 
3. add web.xml to expose the servlet
4. build container, run locally:
```
docker build --no-cache -t app-demo .
docker run -it -p8080:8080 app-demo
```
5. test locally:
```
curl  http://localhost:8080
```
6. add github action to build the container
7. extend github action to push the container to ghcr.io (free for small projects)
8. create folder k8s with deployment yamls for the service
9. create a locally running k3s cluster
10. test servlet running in kubernetes:
```
k3s kubectl -n app-demo port-forward deployment/app-demo 8080:8080
curl  http://localhost:8080
```

# Adding EC2/RDS components
1. setup access from my local box to my aws account using aws cli tool
2. created terraform plans to provision an EC2 instance. plans are located in folder 'terraform'. 
3. manually create key pair in the terraform folder as follows:
```
ssh-keygen -f mykey -t rsa
```
4. the terraform plans are s hardcoded to use the local key pair it when provisioning the ec2 instance.
5. run terraform as follows:
```
cd terraform
terraform init
terraform apply
```
5. add ansible code to deploy the app to the provisioned host, see ansible/README.md for more details