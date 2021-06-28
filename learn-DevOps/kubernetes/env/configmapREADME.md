we can create configmap with impertive way so command will be 

	$ kubectl create configmap myconfig --from-literal=key=value

 --from-literal mean you have to specify key and values in command

2nd way is to create config map and provide key-value pairs in file you can create by 

	$ kubectl create configmap myconfig --from-file=mykeyvalue.txt

 in this mykeyvalue.txt is file in which we have provided keyvalue so you can create configmap
by file 

	
	configmap by Declarative

	apiVersion: v1
	kind: configmap
	metadata:
	  name: app-config
	data:
	  key: value
	  key: value
and then you can 
	$ kubectl create -f config-map.yaml

after creating config map you have to configure with pod

	apiVersion: v1
	kind: Pod
	metadata:
	  name: web-app
	  labels:
	    name: web-app
	spec:
	  containers:
	  - name: web-app
	    image: aamirpinger/helloworld:latest
	    ports:
	      - containerPort: 8080
	    envFrom:
	      - configMapRef:
                  name: app-config
