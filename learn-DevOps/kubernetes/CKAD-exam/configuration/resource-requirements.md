		Resource Management

minimum requriement from the pod 

cpu = 0.5
mem = 256 Mi
disk= 

you can define resource management when creating pod so as example

apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp-color
  labels:
    name: simple-webapp-color
spec:
  containers:
  - name: simple-webapp-color
    image: simple-webapp-color
    ports:
      - containerPort: 8080
    resources:
      requests:
        memory: "1Gi"
        cpu: 1


---------------------
1 cpu count really mean so its like that 

0.1 cpu mean 100m (here m stands for mili) you can mentions 1m but not lower then

i cpu is equal to 

* 1 aws vCPU
* 1 GCP Core
* 1 Azure Core
* 1 Hyperthread


1Gi= 1GB

------------------------
you can also specifiy memory allocation for the container like this 


=> 256Mi
=> 268M
=> 1G 


diffrence between G and Gi

G is gigabyte = 1000mb mega bite
Gi  is 1024 mi 

complete picture like this


	1 G (Gigabyte) = 1000,000,000 bytes
	1 M (Megabyte) = 1,000,000 bytes
	1 k (Kilobyte) = 1000 bytes

	1 Gi (Gibibyte) = 1,073,741,824 bytes
	1 Mi (Mebibyte) = 1,048,576 bytes
	1 Ki (Kibibyte) = 1,024 bytes

----------------------------

on docker there is no limit for container that how much it consume memory 

by default in kubernetes containers difine as 1vcpu usage and limited to use 1vcpu and 
as usage of memory kuberntes by default 512mi limit to usage as memory on containers
you can mentions your self by pod-definition file 

apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp-color
  labels:
    name: simple-webapp-color
spec:
  containers:
  - name: simple-webapp-color
    image: simple-webapp-color
    ports:
      - containerPort: 8080
    resources:
      requests:
        memory: "1Gi"
        cpu: 1
      limits:
        memory: "2Gi"
        cpu: 2
-----------------------------

you need to define resources for every container so in case if container used total
limit of cpu it can not use more then that which define it throttle the cpu

in case of memeory container can use more memoery then which you have specified but if
pod try to consume more memory frequently it will be terminated  
