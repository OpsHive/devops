service account are accounts which are used by application talk to the cluster
like prometheous used to scrap cluster matrix and show in dashboard another example
is jenkins which are used to deploy application which need to talk to cluster
so for these type of applications used service accounts 

you can simply create with 

 $ kubectl create serviceaccount dashboard-sa
 $ kubectl create sa dashboard-sa

-----------------------------------

when we have created a service account it create secrets autometically which are
used to store token which needs by application you can view

 $ kubectl get secrets 

-----------------------
so after that you need to provide this service account into your deployment

apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  containers:
  - name: my-pod
    image: nginx
    ports:
    - containerPort: 80
  serviceAccount: dashboard-sa

--------------------------------------------------
there are a default service account which mounted in every pod when created automatically if you dont want to mount this 
default service account you can mention as automountServiceAccountToekn: false

for example

apiVersion: v1
kind: Deployment
  name: my-app
spec:
  containers:
    - name: my-pod
      image: nginx
      ports:
      - containerPort: 80
  automountServiceAccountToken: false


