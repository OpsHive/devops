		TAINTS AND TOlERATION IN KUBERNETES

when user deploy many pod on more than 1 nodes sechduler take that pods and deploy
equal them equaly on available nodes but in case when you want to deploy a specific
pod on a specific node which have availble resources for running a specific pod so
we can mention taint on node to prevent deploy pod on that node, so if you want to
deploy specific pod on that node we have to mention in pod toleration so node will 
allow tolerated pod to deploy on it.

so taints are set on nodes and tolerations are set on pods

for taints on node we can speifiy by this command


	$ kubectl taint nodes <node-name> <key=value>:taint-effect


effects should be NoSchedule | PreferNoSchedule | NoExecute

NoSchedule = not Schedule any pod which is not tolerate
PreferNoSchedule = try to not schedule pod on that node but ther is not gurntee.
NoExecute = new pod will not schedule on node and existing pod if not tolerate will 
		victims 

for example

	$ kubectl taint nodes node1 app=blue:NoSchedule

tolerations added to pod in pod defination file at spec level values which we have 
added must be equal to node taint values so in that case node tolerate the pod

	apiVersion: v1
	kind: Pod
	metadata:
	  name: myapp-pod
	spec:
	  containers:
	  - name: nginx-container
	    image: nginx
	  tolerations:
	  - key: "app"
	    operator: "Equal"
	    value: "blue"
	    effect: "NoSchedule"


if you want to remove taint form the node

	$ kubectl taint nodes node01 app=blue:NoSchdelue-

