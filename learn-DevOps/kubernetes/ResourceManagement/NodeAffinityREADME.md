		Node Affinity

node affinity has more specification as compare to node selector node affinity is 
more complex than node slector for example

	apiVersion: v1
	kind: Pod
	metadata:
	  name: my-pod
	spec:
	  containers:
	    - name: my-pod
	      image: qasim683/djamdin
	  affinity:
	    nodeAffinity:
	      requiredDuringSchedulingIgnoredDuringExecution:
	        nodeSelectorTerms:
	        - matchExpressions:
	          - key: size
	            operator: In
		    values:
	            - Large
		    - Medium

in this affinity we said deploy pod on those nodes which have labels Large or Medium
either you can specify operator like In,NotIn,Exists etc,  NotIn mean deploy pod on that
nodes which not have labels of Large,Medium ...
in case of Exists not need of values to mention just key: size and operator Exists

there are two type of node affinity avaialble

	requiredDuringSchedulingIgnoreDuringExecution
	preferredDuringSchedulingIgnoreDuringExecution

Planned:
	requireDuringSchedulingRequireDuringExecution


