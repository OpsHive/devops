		Readiness Probes

pod has some conditions and status, when user create contianer in start its in 
pendding state after some time scheduler place pod on any node and start container
creating state when it pulls image and start container it will be then in Running
state .....

Pod Conditions

Pod Scheduled  TRUE FALSE
initialized    TRUE FALSE
ContainersReady TRUE FALSE
Ready          TRUE FALSE

you can view this pod conditions by following command in conditions sections

	$ kubectl describe pod <pod-name>

so when container in ready state its mean now application is ready in ready state
to recive traffic but some time some server take more time to be ready and recive
trafic for this purpose web create Readiness probes its like a test to check 
application is ready to recive trafic or not and after checking with some http
request when confirm readiness prob tell kubernets to send trafic until it remain
container or application in pendding state....

we can define readiness prob in pod defination yaml file at
  spec.container.readinessProbe

for example
		apiVersion: v1
		kind: Pod
		metadata:
		  name: myapp
		spec:
		  containers:
		  - name: myapp
		    image: myapp/app
		    ports:
		      - containerPort: 8080
		    readinessProbe:
		      httpGet:
		        path: /api/ready
		        port: 8080



there are 3 ways of readiness prob whcih are httpGet , tcpSocket and exac command

httpsGet
		readinessProbe:
		  httpGet:
		    path: /api/ready
	            port: 8080

TCP Test -3306 (its use case of checking for database on port 3306 is listening)
		
		readinessProbe:
		  tcpSocket:
		    port: 3306

Exec Command (its like type command within container and check container state)

		readinessProbe:
		  exec:
		    command:
		      - cat
		      - /app/is_ready


---------------------------------------------------------------
 
user can also mentions initialDelaySeconds, periodSeconds, failureThreshold,
 under readinessProbe,

	readinessProbe:
	  httpGet:
	    path: /api/ready
	    port: 8080
	  initialDelaySeconds: 10
	  periodSeconds: 5
	  failureThreshold: 8

 


