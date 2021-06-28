		KUBERNETES SECURITY

as secruity in docker container you can provide at pod level as well so if docker container 
run in pod so pod security overide the setting of container security

so if you want to add secruity at pod level you can define in yaml file at pod level
for example ...

	apiVersion: v1
	kind: Pod
	metadata:
	  name: web-pod
	spec:
	  securityContext:
	    runAsUser: 1000
	  contianers:
	    - name: ubuntu
	      image: ubuntu
	      command: ["sleep", "3600"]

so if you want to create security at container level

        apiVersion: v1
        kind: Pod
        metadata:
          name: web-pod
        spec:
          contianers:
            - name: ubuntu
              image: ubuntu
              command: ["sleep", "3600"]
	      securityContext:
	        runAsUser: 1000
	        capabilities:
	          add: ["MAC_ADMIN"]
