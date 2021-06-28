	multi-container pod

there are diffrent patterns to create multi-container pod

*Ambassador
*Adapter
*Sidecar



sidecar
-------
there are many situations in which you need to create multicontainers pod one of them
for example if you want to deploy application which need to download source code from
git hub every time when pod created so in that senerio you need a sidecar container
which curl the source code and place this code into container then you just need a volume
mount which mount this code on host and within pod containers are sharing the host volumes
so in second container you just mount this volume into container 



apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: sidecar
    image: ubuntu
    commands:
    - "git clone https://github.com/qasim683/myapp.git"
    volumeMounts:
    - name: app-code
      mountPath: ./
  - name: nginx
    image: nginx
    volumeMounts:
    - name: app-code
      mountPath: /var/www/html
  volumes:
  - name: app-code
    hostPath: /data
--------------------------------

adapter:
  adapter container is need 
