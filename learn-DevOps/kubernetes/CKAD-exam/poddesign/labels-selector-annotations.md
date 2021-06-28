labels are used to group kubernetes objects togather so first you labeld you objects with
key value pair and then use selector to  combine togather filter, serach etc

you can define labels in object-definition.yaml here like pod 


apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
   app: nginx-server
   tier: frontend
spec:
  containers:
  - name: mypod
    image: nginx
    ports:
    - containerPort: 80


------------------------------------------------------------

you can filter by selector

 $ kubectl get pod --selector tier=frontend


annotations:
------------
annotations are used to store more informations about object we can define under metadata

apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    app: nginx-server
    tier: frontend
  annotations:
    buildversion: 1.34
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80

