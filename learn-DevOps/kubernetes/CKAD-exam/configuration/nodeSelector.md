	Node Selector


in kubernetes if you want to place a require pod on a specific node you can do
with node selector,(by default in kubernetes any pod can be go on any node)
 for example if A-node have a high resource and B-node has low
resources, so the pod-A need to depoy on A-node and pod-B need to deploy on B-node we can 
achive this kind of senerio by node selector 

you need to first label you node which have high resources available....


 $ kubectl label nodes <node-name> <label-key>=<label-value>

 $ kubectl label nodes node-1 size=large

---------------------------------------------

once you have label node then you need to define when creating pod-definition.yaml file


apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  containers:
  - name: my-app-pod
    image: nginx
  nodeSelector:
    size=Large

------------------------------------------

Node Selector Limitations 

if we have labeled two node node-A is large node and node-B is medium node and we want
to place a pod which can be deployed either on large or medium but not on small node we can
not achive this by node selector for this node affinity 
