		some security basics on the network policies

in case we have deploy forntend, backend, and database so .....
frontend server which is reciving requiest on port 80 and send it to backend pod
which is listning on port 5000 and then backend fetch data from database on port
3306 and then send data back to the user so there are two types of traffic

so when recive trafic from the user on frontend port 80 is ingress traffic and
frontend pod send to back end trafic calls Egress traffic ,,here when backend 
recive traffic from frontend api is also called ingress and backend further send 
to data base is Egress traffic 

	what is ingress traffic and Egress traffic

when frontend recive traffic from the user it calls ingress trafic and when frontend
send it to backend api its called Egress . . . . .

similarly

when backend api recived traffic from frontend it calls ingress and backend api send
it to database calls Egress traffic . . . . . . . . . . .

frontend	ingress 80	<------------	from user
		Egress 5000	------------>	to backend api
 
backend		ingress 5000	<------------	from frontend api
		Egress	3306	------------>	to database

database	ingress 3306	<------------  from backend api


		Network Security

by default all pods can communicate within the cluster what if we dont want to
frontend pod communicate directly with the data base that is where you impliment 
network policy to allow traffic to the db server only from the backend api server
	
Network policy is another object of the  kubernetes like, pod,svc,rs,deploy etc

in network policy we can set rules that the db accept only trafic from the backend api
so for that we use labels and selectors 

so in example we only allow ingress traffic from the backendapi pod on port 3306

we can create with newtworpolicy defination yaml file ......


		apiVersion: networking.k8s.io/v1
		kind: NetworkPolicy
		metadata:
		  name: db-pod
		spec:
		  podSelector:
		  matchLabels:
		    role: db
		  policyTypes:
		  - Ingress
		  ingress:
		  - from:
		    - podSelector:
		        matchLabels:
		          name: api-pod
		    ports:
		    - protocol: TCP
		      port: 3306


Note:-------

Solutions that Support Network Policies:

	- kube-router
	- calico
	- romana
	- weave-net

