	secrets in kubernetes

you can pass senstive information like database password,host,username as secrets in 
kubernetes  so there two steps to use secrets first create secrets and then inject these
secrets into pod

create secrets
--------------

impertive way to create secrets

 $ kubectl create secret generic <secret-name> --from-literal=<key>=<value>

 $ kubectl create secret generic my-secret --from-literal=DB_HOST=mysql


secrets using secret file

 $ kubectl create secret generic <secret-name> --from-file=<path-of-file>

 $ kubectl create secret generic app-secret --from-file=secrets.txt

------------------------------------------------------------------

declarative approch
-------------------

apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_HOST:
  DB_USER:
  DB_PASSWORD:

----------------------

configure secrets in pod


apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp-color
  labels:
    name: simple-webapp-color
spec:
  containers:
  - name: simple-webapp-color
    image: simple-webapp-color
    ports:
      - containerPort: 8080
    envFrom:
      - secretRef:
          name: app-secret
-----------------------------------------------------

there are many ways to injects secrets into pod

inject as all env as once
------------------------

envFrom:
  - secretRef:
      name: app-config

------------------------

single env 
----------

env:
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: app-secret
        key: DB_PASSWORD

------------------------

env as volume:

volumes:
- name: app-secret-volume
  secret:
    secretName: app-secret

---------------

secrets as volume mounts into pod
---------------------------------


apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp-color
  labels:
    name: simple-webapp-color
spec:
  containers:
  - name: simple-webapp-color
    image: simple-webapp-color
    ports:
      - containerPort: 8080
    volumeMounts:
    - mountPath: /opt/test-ebs
      name: app-secret
  volumes:
  - name: app-secret-volume
    secret:
      secretName: app-secret

