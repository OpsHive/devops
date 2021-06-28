when we create docker image we specifi cmd for example

 docker run --name ubuntu-sleeper ubuntu-sleeper
 docker run --name ubuntu-sleeper ubuntu-sleeper 10

	FROM Ubuntu
	ENTRYPOINT ["sleep"]
	CMD ["5"]

so if you want to modify docker CMD  in pod defination file you can mention in
 spec.containers.args like this 

	apiVersion: v1
	kind: Pod
	metadata:
	  name: ubuntu-sleep-pod
	spec:
	  containers:
	    - name: ubuntu-sleeper
	      image: ubuntu-sleeper
	      args: ["10"]

and if you want to modigy docker ENTRYPOINT in pod defination file you can overide with
 spec.containers.command

	apiVersion: v1
        kind: Pod
        metadata:
          name: ubuntu-sleep-pod
        spec:
          containers:
            - name: ubuntu-sleeper
              image: ubuntu-sleeper
	      command: ["sleep"]
              args: ["10"]

