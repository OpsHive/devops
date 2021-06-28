       
		HOW TO SWITCH BETWEEN NAMESPACE

 kubectl config set-context --current --namespace=dev
 
 kubectl config set-context --current --namespace=default

	HOW TO CHANGE OWNERSHIP OF FOLDER OR FILE 

	sudo chown -R $USER /home/qasim/.minikube
	sudo chown -R $USER /usr/local/bin/kubectl 
---------------------------------------------------------------

	how to access objects from another namespace

for example we have create data base service which connect db pod in dev namespace and we are on prod namespace so we can reffrence it 
through their dns name like 

for examle 

	mydb-dvc.dev.svc.cluster.local

	service-name.namespace.service.domain

		
-----------------------------------------------------------------

		how to create,get,delete namespace

you can get all name space 

	$ kubectl get namespace
	$ kubectl get ns

you can view all objects of all namespaces by 

	$ kubectl get pods --all-namespaces

you can create name space by

	$ kubectl create namespace dev

you can list or get objects of name space by 

	$ kubectl get pod --namespace=dev
	$ kubectl get pod -n dev


create namespace with yaml definiation file

apiVersion: v1
kind: Namespace
metadata:
  name: prod

-------------------------------------

you can provide you limit you namespace by resource qouta so for this you need to create
object resourcequota with following yaml formate


apiVersion: v1
kind: ResourceQuota
metadata:
  name: my-dev-Quota
  namespace: dev
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "3"
    limits.memory: 5gi
