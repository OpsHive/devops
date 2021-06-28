		Node Affinity
		-------------

if we have labeled two node node-A is large node and node-B is medium node and we want
to place a pod which can be deployed either on large or medium but not on small node we can
not achive this by node selector for this we used  node affinity

we can define node affinity in pod yaml file like this

apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  containers:
  - name: data-processor
    image: data-proccessor
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

----------------------------------------

Node Affinity Types

Available:
---------

	requireDuringSchedulingIgnoreDuringExecution
	preferredDuringSchedulingIgnoreDuringExecution
Planned:
-------

	requireDuringSchedulingRequireDuringExecution

------------------------------------------------

you can also add node affinity like this after spec


apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: node-role.kubernetes.io/master
            operator: Exists
  containers:
  - name: data-processor
    image: data-proccessor
  
