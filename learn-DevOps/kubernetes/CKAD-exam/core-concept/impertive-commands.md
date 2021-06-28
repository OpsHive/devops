			POD impertive commands


	for creating pod menifest

$ kubectl run nginx --image=nginx --dry-run=client -o yaml

	for deployemnt menifest

$ kubectl create deployment --image=nginx --dry-run -o yaml



------------------------------------------
			DEPLOYMENTS impertive commands


genrate deployment with 4 replicas so in this case you first create deployment

$ kubectl create deployment nginx --image=nginx

so when you have created successfully deployment scale it with 4 replicas by

$ kubectl scale deployment nginx --replicas=4

if you want to made more modification in yaml you can genrate with --dry-run by 

$ kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > my-deploy.yaml

---------------------------------------------------------

			SERVICES impertive commands
CLUSTER IP
----------

$ kubectl expose pod redis --port=6379 --name=redis-service --dry-run=client -o yaml

or

kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml

NODE PORT
---------

$ kubectl expose pod nginx --port=80 --name nginx-service --dry-run=client -o yaml
	(this will automatically use the pod's labels as selectors you can edit and mentions
	node port yourself)

or

$ kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml > nginx-svc.yaml



