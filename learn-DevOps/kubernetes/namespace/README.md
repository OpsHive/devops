you can create Name space with impertive way by command

	$ kubectl create namespace dev


you can also create by yaml file by

	$ kubectl create -f namespace.yaml


		apiVersion: v1
		kind: Namespace
		metadata:
		  name: dev



you can also mention name space in pod yaml file in meta data with tag namespce: dev

		apiVersion: v1
		kind: Pod
		metadata:
		  namespce: dev
		  name: myapp-pod
		  labels:
		    app: myapp
		    type: front-end
		spec:
		  containers:
		    - name: nginx
		      image: nginx


for listing of name space objects you can use

	$ kubectl -n dev get pods,svc,deploy,rc,cm,secret

you can also connect some resource of default name spce  other name space resources
for example you can connect db of default name space to dev name space service by this command

	$ mysql.connect("db-service.dev.svc.cluster.local")
		service Name - namespce - service - domain


you can switch between diffrent namespaces 
 
	$ kubectl config set-context $(kubectl config current-context) --namespace=dev
so when you set your current context to dev you can list your objects through

	$ kubectl get pods,deploy,cm,svc,secret,rs
all listing should be dev name space 

you can also view objects of all name space by this command 

	$ kubectl get pods --all-namespaces

you can alocate resource Qouta to your name space by compute-quota.yaml file create
 object of Resource Quota.

			apiVersion: v1
			kind: ResourceQuota
			metadata:
			  name: compute-quota
			  namespace: dev
			spec:
			  hard:
			    pods: "10"
			    requests.cpu: "4"
			    requests.memory: "5Gi"
			    limits.cpu: "10"
			    limits.memory: 10Gi			

