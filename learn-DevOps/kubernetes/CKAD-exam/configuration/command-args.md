	COMMAND AND ARGS IN DOCKER 

in docker commands are known as entrypoint in docker file 

and 

args is known as cmd

for example we need to run ubuntu-sleeper and want to sleep container 10 seconds so 
dockerfile should be like this

FROM ubuntu

ENTRYPOINT ["sleep"]

CMD ["10"]


----------------------------------------------------

	COMMAND AND ARGS IN K8S

in pod yaml definition file we use entrypoint as command, and cmd as args

for example 

apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: my-pod
    image: ubuntu-sleeper
    command: ["sleep"]
    args: ["10"]


and you can also provide all commands in commad as array

command: 
  - "sleep"
  - "10"

