	configmap in kubernetes

there are two setps to configure values as configmap env so 1 is create config map as 
key value pair and then inject into pod 

we can create config map by imertive commands and also yaml defination file for impertive way
we can use this command


 $ kubectl create configmap my-config --from-literal=key=value

for example

 $ kubectl create configmap app-config --from-literal=APP_COLOR=pink


----------------
create configmap as impertive way by file so first you need to create file which has
configmap key value pairs then you can create config map by this file for example
we have create env.txt and it has following value

APP_COLOR=pink

then 

 $ kubectl create configmap my-config --from-file=env.txt

------------------
declarative way approch to create configmap

apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  APP_COLOR: pink

 $ kubectl create -f config-map.yaml

------------------------
		HOW TO INJECT CONFIGMAP INTO POD

apiVersion: v1
kind: Pod
metadata:
  name: myapp
spec:
  containers:
  - name: my-color-app
    image: simple-webapp-color
    ports:
    - containerPort: 8080
    envFrom:
    - configMapRef:
        name: my-config
     
---------------------------
as single env

env:
  - name: APP_COLOR
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: APP_COLOR
---------------------------

we can pass config map as volume

volumes:
  - name: app-config-volume
    configMap:
      name: app-config
------------------------------

we can pass configmap as volume and mount them into container file system

apiVersion: v1
kind: Pod
metadata:
  name: myapp
spec:
  containers:
  - name: my-color-app
    image: simple-webapp-color
    ports:
    - containerPort: 8080
    volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: my-config
--------------------------

