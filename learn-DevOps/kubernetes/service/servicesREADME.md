	Kubernetes Service

services enable communication between various components within outside of 
application , services helps us connect applications togather  with other applications
and users , for example our application running pod for diffrent services frontend,
backend, database these all pod needed to connect with each other like frontend 
connect with backend and backend need to fetch data from database so for that 
purpose we use clusterIP type service to connect frontend with backend and also 
backend connect with database. 

so in example where we want to curl the application which is container within 
the pod and pod is deployed on the node so want to excess from own laptop,,,,

in this case we used node port to expose a port on the node and this port redirect
traffic on the containers port (for example on the port 80).. in other words we 
are exposing port 80 on the nodeport so now we can access this pod from own laptop..


	$ curl ip-address-of-node:nodePort
	
	$ curl 54.35.25.1:30058

		Services Types


1. NodePort

2. ClusterIP

3. LoadBalancer


		NodePort

nodeport is used to expose internal port of container on the node to listen requiest.

there are three ports envolve in this sernerio nodeport, serviceip-port and
pod port , when we expose the port 80 on the nodeport, first the container port reffers
to the service ip port and this serviceip reffers to the nodeport 

nodeports are in range 30000 to 32767 

How to create service ?

we can create with Service-defination yaml file 


		apiVersion: v1
		kind: Service
		metadata:
		  name: myapp-service
		spec:
		  type: NodePort
		  ports:
		    - targetPort: 80
		      port: 80
		      nodePort: 30008

so for here a one case is that if on cluster we are using many pods with port 80
so how we deffreniate a specific pod so for these case is best practice to create
service with labels and selectors so with labelSelector we can select our target pods
 

		apiVersion: v1
                kind: Service
                metadata:
                  name: myapp-service
                spec:
                  type: NodePort
                  ports:
                    - targetPort: 80
                      port: 80
                      nodePort: 30008
		  selector:
		    app: myapp
		    type: front-end

so now you can creaete with kubectl command

	$ kubectl create -f service-defination.yaml


		ClusterIP

it create virtual ip inside the cluster to enable communication between diffrent 
services, such as front end server to communicate with backends.and backend needed
to fetch data from database . so group these pods with one static ip which clusterIP
so in this case we need to use 2 clusterIP ,,
one is for coneecting frond-end pod with back end, and second clusterIP for connecting
back-end with the database.....

	How to create clusterIP service ?
we can create it with service defination yaml file.........

		apiVersion: v1
		kind: Service
		metadata:
		  name: back-end
		spec:
		  type: ClusterIP
		  ports:
		    - targetPort: 80
		      port: 80
                  selector:
		    app: myapp
		    type: back-end

here selector use labels of the pod to bind with the ClusterIP service..

	$ kubectl create service-defination.yaml




		LoadBalancer

load balancer are used to blancer load on verious servers with distributed manner
load balncer ensure to divide traffic on diffrent instances of the servers


	

	
