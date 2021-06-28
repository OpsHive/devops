		RESOURCE MANAGEMENT

cluster is a combination of nodes which have some resources. every node has its own
resources so when user create any kubernetes object sechduler look for resources on 
nodes and if schduler find available rasource it will create user required object 
on node where resources available, if sechduler find all nodes resource insuffeicent
for object require resources it will show it in pending mode so when ever resources 
are availble it will deploy on  it.

you can define you requested resources for pod-contianer when creating you have to
mention in yaml file in spec.container.resources for example

	apiVersion: v1
	kind: Pod
	metadata:
	  name: web-app
	  labels:
	    name: web-app
	spec:
	  containers:
	  - name: web-app
	    image: webapp-color
	    ports:
	      - containerPort: 8080
	    resources:
	      requests:
	        memory: "1Gi"
	        cpu: 1


resource with limit in yaml file 

apiVersion: v1
        kind: Pod
        metadata:
          name: web-app
          labels:
            name: web-app
        spec:
          containers:
          - name: web-app
            image: webapp-color
            ports:
              - containerPort: 8080
            resources:
              requests:
                memory: "1Gi"
                cpu: 1
	      limits:
	        memory: "2Gi"
		cpu: 2


you can also specify maximum limts for resourecs for cpu limit if limit exceed in case
of cpu it will throttle cpu and unable to use more cpu above the limit but in memory 
meximum usage it will go for all available memory but when exceed from the pod memoery
limits continuesly  pod will be terminated

