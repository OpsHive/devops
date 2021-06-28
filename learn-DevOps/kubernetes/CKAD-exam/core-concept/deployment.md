		what is deployment

deployment provide the capability to upgrade the underline instances seemlesly using rolling
updates ,undo changes, and pause and resume changes as required 

		how to create deployments

apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: my-pod
      labels: 
        app: mynginx
        type: server
    spec:
      containers:
      - name: my-nginx-server
        image: nginx
  replicas: 3
  selector:
    matchLables:
      app: mynginx

		

		HOW TO GENRATE DEPLOYMENT YAML WITH DRY RUN

	$ kubectl create deployment nginx-server --image=nginx --dry-run=client -o yaml > nginx-server.yaml

it will genrate a dumpy deployment yaml you can edit it and specify all you need and apply for create deployment
