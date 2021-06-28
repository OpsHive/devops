		Headless Service in k8s

so in statefull sets pods will be created with ordered manaer and name would be assign
with name and index number for each replicas so in cluster communication should be through
services with unique ip address of pods but when pod deleted and created new one they
change thier ips now name are static but ip's are dynamic for this sulotion we need
headless service which is denoted by dns name (we need to point master mysql so for that
we need to create headless service)


so dns will be created in manner 
	(podname.headless-servicename.namespace.svc.cluster-domain)

for example

(mysql-0.mysql.default.svc.cluster.local)
(mysql-1.mysql.default.svc.cluster.local)
(mysql-2.mysql.default.svc.cluster.local)


	how to create Headless Service

it will be created as another service defination yaml file

apiVersion: v1
kind: service
metadata:
  name: mysql-h
spec:
  ports:
    - port: 3306
  selector:
    app: mysql
  clusterIP: none


so how to use it in pod defination yaml file

apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: mysql
spec:
  containers:
  - name: mysql
    image: mysql
  subdomain: mysql-h


it will create dns record for the name of the service to point to the pod .however
still does'nt create a record for indivdual pod so for that you must specify hostname

apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: mysql
spec:
  containers:
  - name: mysql
    image: mysql
  subdomain: mysql-h
  hostname: mysql-pod


--------------------------------------------------------------------------------

so this is okay for pod but when you create statefullset there is no need to specify
subdomain and hostname it can automaticly configure you have to only specify
serviceName: mysql-h in spec.serviceName

apiVersion: apps/v1
kind: StatefullSet
metadata:
  name: mysql-server
  labels:
    app: mysql
spec:
  serviceName: mysql-h
  replicas: 3
  matchLabels:
    app: mysql
  template:
    metadata:
      name: myapp-pod
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql
