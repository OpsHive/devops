		security context in kubernetes


in kuberntes security context of docker can be  overide by the pod defination

like this 

apiVersion: v1
kind: Pod
metadata:
  name: web-pod
spec:
  securityContext:
    runAsUser: 1000
  containers:
    - name: ubuntu
      image: ubuntu
      command: ["sleep", "3600"]
 
if you wish to provide security context at containers level 

apiVersion: v1
kind: Pod
metadata:
  name: web-pod
spec:
  containers:
    - name: ubuntu
      image: ubuntu
      command: ["sleep", "3600"]
      securityContext:
        runAsUser: 1000
        capabilities:
          add: ["MAC_ADMIN"]

-------------------------------------------------------------

HOW TO CHECK USER OF CONTIANERS 

kubectl exec ubuntu-sleeper --whoami
