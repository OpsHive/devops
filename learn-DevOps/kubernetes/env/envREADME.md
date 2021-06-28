env of kubernetes will be define in pod defination with env array it will take keys and thier 
values attribute.

	apiVersion: v1
	kind: Pod
	metadata:
          name: mypod
        spec:
          containers:
	    - name: mypod
              image: aamirpinger/helloworld:latest
	      env:
                - name: myenv
                  value: something


in case of configmap env template should be 

	apiVersion: v1
	        kind: Pod
	        metadata:
	          name: mypod
	        spec:
	          containers:
	            - name: mypod
	              image: aamirpinger/helloworld:latest
	              env:
	                - name: myenv
	                  valueFrom:
	                    configMapKeyRef:

in case of secrets env template should be 

	apiVersion: v1
        kind: Pod
        metadata:
          name: mypod
        spec:
          containers:
            - name: mypod
              image: aamirpinger/helloworld:latest
              env:
                - name: myenv
                  valueFrom:
		    secretKeyRef:
