		SERVICE ACCOUNT IN KUBERNETES

thier are two types of accounts in kubernetes User account and Service account
user account used by users (humans) for example admnistartor for acessing 
clusters or devlopers to create application on kubernetes
 and service accounts used by applications to intrect with clusters for example
Prometheus and jenkins (jenkins used to deploy application on clusters)

for example kubernetes dashboard send request to cluster for  showing the details
of pods on cluster and desplay on kubernetes dashboard for this pupose k8s dashbord 
have to be authenticated for that we used service account. we can create service 
account by this command.....

	$ kubectl create serviceaccount dashboard-sa

similarly you can view listing by 

	$ kubectl get serviceaccount

and 

	$ kubectl describe sa <service-account-name>

when we create a service account it create an object of service account with token
and this token will be saved as secret so if you list your secrets thier is one more
secret created realed to newly created service account you can view it by

	$ kubectl get secrets 

and also you can 

	$ kubectl describe secret dashboard-sa-token-sdafa5

-------------------------------------------------------------------------
		

		How to use serviec account in pod yaml

when you list the service account thier will be a default service account this 
account automaticaly mounted in every pod thier is no need to mention
its location in pod will be /var/run/secrets/kubernetes.io/serviceaccount


so if you create a new service account it must be mounted within pod in pod
defination file for example

	apiVersion: v1
	kind: Pod
	metadata:
	  name: my-dashboard
	spec:
	  containers:
	    - name: my-dashboard
	      image: my-kubernetes-dashboard
	  serviceAccount: dashboard-sa

remember you can not edit the service account of existing pod you have to delete and 
create new pod with decaling serviceAccount in yaml file

in case of deployment you can edit the serviec account

kubernetes automaticaly mount default service account in every pod if you wish 
not mount default service account you have to mention in yaml file for example.....

	apiVersion: v1
        kind: Pod
        metadata:
          name: my-dashboard
        spec:
          containers:
            - name: my-dashboard
              image: my-kubernetes-dashboard
          automountServiceAccountToken: false


 

