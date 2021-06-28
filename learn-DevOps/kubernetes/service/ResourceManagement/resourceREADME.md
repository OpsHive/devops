		RESOURCE MANAGEMENT

every node in cluster have availble resource like cpu's memory diskspace so the master node 
componenet sechduler decide, how many resource will be consume by the pod and sechdule a pod
on node where resources available if node dont have suffiecent resource sechduler will place 
pod to another node where resource available and if all nodes fully utilized sechduler place 
pod in pending state so when ever 1 more node will be added to cluster and  resource available
it will sechdule this pending pods.

you can mention in your pod yaml file how much resource you want to utilits for running 
a specific container for example

	apiVersion: v1
	kind: Pod
	metadata:
	  name: simple-webapp
	  labels:
	    name: simple-webapp
	spec:
	  containers:
	  - name: simple-webapp
	    image: simple-webapp-color
	    ports:
	      - coontainerPort: 8080
	    resources:
	      requests:
	        memory: "1Gi"
	        cpu: "1"

you can also specify limits for maximum resource usage

	apiVersion: v1
        kind: Pod
        metadata:
          name: simple-webapp
          labels:
            name: simple-webapp
        spec:
          containers:
          - name: simple-webapp
            image: simple-webapp-color
            ports:
              - coontainerPort: 8080
            resources:
              requests:
                memory: "1Gi"
                cpu: "1
	      limits:
	        memory: "2Gi"
	        cpu: 2


if cpu limits exceed, it throttle cpu and cannot use more cpu over thier specified limit
 in case of memory it can use more than specified limit if needed but when exceed the whole
limit of pod it will terminate the pod 

1 cpu is qual to :

	* 1 AWS vCPU
	* 1 GCP Core
	* 1 Azure Core
	* 1 Hyperthread

