		env in docker 

you can specifiy env in docker command like this

	
$ docker run -e APP_COLOR=pink simple-webapp-color


		env in k8s
		----------

we can provide env in pod definition yaml file as following

apiVersion: v1
kind: Pod
metadata:
  name: simple-color-app
spec:
  containers:
  - name: simple-webapp-color
    image: simple-webapp-color
    ports:
    - containerPort: 8080
    env:
    - name: APP_COLOR
      value: pink

----------------------------------------------

env as plain key value pair
---------------------------
env:
  - name: APP_COLOR
    value: pink

env as configmap
----------------
env:
  - name: APP_COLOR
    valueFrom:
      configMapKeyRef:


env as secret
-------------
env:
  - name: APP_COLOR
    valueFrom:
      secretKeyRef:

