		Multi-Container Pods

in Genral there are three types of Multi-container Pod Ambassador, Adapter, Sidecar
in some situation Microservices needed to run helper container with Main containers
for supporting in this case we use Multi-container Pod, they used same lifecyle ,
mean they work togather ,create togather, and also die togather they are using
same localhost and networking, storage in a pod

example of Multi-container yaml file 
	
	apiVersion: v1
	kind: Pod
	metadata:
	  name: simple-webapp
	  labels:
	    name: simple-webapp
	spec:
	  containers:
	  - name: simple-webapp
	    image: simple-webapp
	    ports:
	      - containerPort: 8080
          - name: log-agent
	    image: log-agent


	Design Patterns in Multi-Container Pod

sidecar,adapter,ambassador

sidecar:
	for example in case of sidecar is contianer which run with main container
and help to genrate log and send to the server

adapter:
	adapter container use when we have multipule applicatio for genrating logs
in different format it is hard to process verious formate to the central logs
server so these log need to convert in common formate for this we use adapter 
container.

ambassador:
	so you application need to communicate with diffrent envirenments with the
databases for example we have dev,test,production envirnment,you need to change 
in configuration in your code depending on envirnment you are deploying
 your application , you need to chose outsource logic in seprate container within your pod
so you application always refers to a local host and this contianer proxy the connection
to right env,

------------------------------------------------------------------------
example of side car container mounting path from host machine into container

apiVersion: v1
kind: Pod
metadata:
  name: app
  namespace: elastic-stack
  labels:
    name: app
spec:
  containers:
  - name: app
    image: kodekloud/event-simulator
    volumeMounts:
    - mountPath: /log
      name: log-volume

  - name: sidecar
    image: kodekloud/filebeat-configured
    volumeMounts:
    - mountPath: /var/log/event-simulator/
      name: log-volume

  volumes:
  - name: log-volume
    hostPath:
      # directory location on host
      path: /var/log/webapp
      # this field is optional
      type: DirectoryOrCreate

