Steps:
1. added maven build that generates a war
2. wrap maven in docker - the Dockerfile build the webapp and creates a deployable image 
3. add web.xml to expose the servlet