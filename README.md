# Welcome to the Aplos DevOps Exercises

We're excited to welcome you to the next stage and would like to see how you approach your work. 

As a reminder, this is really how you think and code. What I am looking for is no more than 20 minutes worth of thinking and an outline of how you would structure your code to accomplish both steps. For each section, it would be good to include some example code, e.g. an ansible file, a docker compose file so we can discuss its contents when we meet up again.  

There are two parts to this. 

## CloudOps

Using the toolset of your choice script the build of the infrastructure to host a simple java web application at Amazon AWS with an **ALB** for routing and a **CDN** for static resources. Assume a single Region (US-East-1) and a single AZ. This should include **network ACLs** and **Security Groups** to allow HTTP/HTTPS connectivity from the public internet as well as allow SSH in from the IP: 1.2.3.4 to the **bastion host**. The **bastion host** should be able to access the **web hosts** via ssh. All hosts should be able to send logs to an **S3** bucket: (s3-logging).

#### VPC
**QA VPC**: (10.0.0.0/16)

- **NACLs**

  - Allow ssh to the bastion host from IP 1.2.3.4
  - Allow http/s to the **ALB**

##### Public subnet
**public-a**: (10.0.100.0/24) should contain the following: 

- **ALB**
- **EC2** (bastion host)

##### Private subnet
**private-a**:  (10.0.200.0/24) should contain the following: 

- **RDS** PostgreSQL
- 2x **EC2** webhosts

The **EC2 webhosts** should run linux (preferably ubuntu) and have either tomcat or resin installed and configured. We use Caucho Resin but most folks are aware of Tomcat, either works. I would expect the compiled **WAR** file to be in the tomcat directory. 

- `hello.war -> /opt/aplos/tomcat/webapps/hello.war`

The **ALB** should have two simple path based routes:

- `/css -> CDN`
- `/img -> CDN`
- `/js  -> CDN`
- `/* EC2`

The **CDN** should be backed by an **S3** bucket: (s3-images).

## RelEng

Using the toolset of your choice script a simple CI/CD pipeline to deploy into the infrastructure above. 

We currently have two build paths, one for our frontend projects (js and css) and one for our backend projects (java). Our backend build process uses **Apache Ant**. Our frontend build process primarily uses **yarn** and other node technologies to build. Our developers currently use a bash script to sequentially build the entire environment (DB, BE and FE) then deploy the packages. Our QA team currently uses a custom python script to build all of the code which on completion will deploy the code to a named environment, e.g. delta01.aplos.com, by automatically running a bash script for deploy. When deploying to production, we run the same deploy script manually on each server. 

For this part, I have created a simple **HelloWorld** java application which you can clone:

- `git clone git@github.com:aplosKevin/devops-nextsteps.git`

This currently uses a *Tomcat* docker image to verify the application works. It does not contain *.js* or *.css* but the */img/aplos.png* should be refreshed on the **CDN**.

You can test locally with the following commands:

### Commands
```
git clone git@github.com:aplosKevin/devops-nextsteps.git
cd aplosDevOps
ant all
docker build -t hello .
docker run -itd -p 8085:8080 hello
curl http://localhost:8080/hello/
```
### Logs
```
aplosDevOps $ ant all
Buildfile: /home/devopser/aplos/aplosDevOps/build.xml

clean:
  [delete] Deleting directory /home/devopser/aplos/aplosDevOps/work
  [delete] Deleting directory /home/devopser/aplos/aplosDevOps/dist

prepare:
   [mkdir] Created dir: /home/devopser/aplos/aplosDevOps/dist
   [mkdir] Created dir: /home/devopser/aplos/aplosDevOps/work/WEB-INF/classes
    [copy] Copying 4 files to /home/devopser/aplos/aplosDevOps/work

compile:
   [javac] /home/devopser/aplos/aplosDevOps/build.xml:49: warning: 'includeantruntime' was not set, defaulting to build.sysclasspath=last; set to false for repeatable builds
   [javac] Compiling 1 source file to /home/devopser/aplos/aplosDevOps/work/WEB-INF/classes

dist:
     [jar] Building jar: /home/devopser/aplos/aplosDevOps/dist/hello.war

all:

BUILD SUCCESSFUL
Total time: 0 seconds
```
```
aplosDevOps $ docker build -t hello .
[+] Building 1.2s (7/7) FINISHED
=> [internal] load build definition from Dockerfile
=> => transferring dockerfile: 36B
=> [internal] load.dockerignore
=> => transferring context: 2B
=> [internal] load metadata for docker.io/library/tomcat:latest
=> [internal] load build context
=> => transferring context: 6.32kB
=> CACHED [1/2] FROM docker.io/library/tomcat@sha256:fe703c02e16ea7d3e8d7bdf5a0c03957f2d4a313cfa9ae44878a3ad12e633ccf
=> [2/2] COPY dist/hello.war /usr/local/tomcat/webapps
=> exporting to image
=> => exporting layers
=> writing image sha256:ae2dba76fb2bc09984b67ad4b980325fa232044eeccf4a083a7ea6b90de90585
=> => naming to docker.io/library/hello
```
```
aplosDevOps $ docker run -itd -p 8085:8080 hello
8403310fe8f0fd4e593d9f7787cd0478c9b038f84430ef3e38ee0f32bc93d154
```
```
aplosDevOps $ curl http://localhost:8080/hello/
<html>
<head>
<title>Hello World</title>
</head>
<body bgcolor=white>
 <table border="0" cellpadding="10">
   <tr>
     <td align=center><img src="img/aplos.png"></td>
     <td>
       <h1>Hello world.</h1>
     </td>
   </tr>
 </table>
 <p>This is the index.html page for the helloworld application.</p>
 <p>Try the following links:
 <ul>
   <li>To a JSP page: <a href="hello.jsp">hello.jsp</a>.
   <li>To a servlet: <a href="hiya">hello</a>.
 </ul>
</body>
</html>
```
