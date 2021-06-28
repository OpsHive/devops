	NODE SELECCTOR IN KUBERNETES

for example you have 3 nodes and 1 of them have heavy hardware resources and other
have low hardware resources in default any pod can go on any node which are not
desired so want to deploy a specific pod on a specific node so when we write 
a pod defination yaml we have to mention thier node selector field in spec section.
for example

	apiVersion: v1
	kind: Pod
	metadata:
	  name: myapp-pod
	spec:
	  containers:
	  - name: mypod
	    image: qasim683/djadmin
	  nodeSelector:
	    size: Large



here size: Large are labels key value pairs on node, so firstly you have to create
labels on node which have heavy resources ......

	How Labels a Node ?

	$ kubectl label nodes <node-name> <key>=<value>
 
	$ kubectl label nodes node1 size=Large


so when create a pod through pod defination yaml file pod will be land on desire node

 
