Steps:
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
6. 