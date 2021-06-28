		Taints and Tolerations

taints are used to deploy pod on a specific node so there are two things involved
one is taints , taints set on a node and tolerate set on pods so only those pod are
deployed on taint setup node which have thier tolerations 

you can add taints on node like this..

 $ kubectl taint nodes <node-name> key=value:taint-effect


there are three type of restriction which we can add

* NoSchedule
* PreferNoSchedule
* NoExecute

when we set noexcute on the node it mean if we already have deployed pod on node and
obvsiouly it dont have toleration so node terminate pod  immediately 

 $ kubectl taint nodes node1 app=blue:NoSchedule

---------------------------

tollerations are metioned at pod in pod defination file 

apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
spec:
  containers:
  - name: nginx-container
    image: nginx
  tolerations:
  - key: app
    operator: Equal
    value: blue
    effect NoSchedule

-------------------------------------------

you can check if node have taints or node by 

 $ kubectl describe node <node-name> | grep -i taint

 $ kubectl describe node node01 | grep -i taint

-----------------------------------

how to remove taints from the node

 $ kubectl taint node <node-name> <taint-and-minus-simbule-at-the-end>

 $ kubectl taint node master node-role.kubernetes.io/master:NoSchedule-


