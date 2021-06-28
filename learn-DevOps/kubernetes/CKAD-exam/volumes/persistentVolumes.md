	volumes in k8s

when we have created and pod we can create volumes in it volumes are created at 
node and remain availble until node is alive and that data from the node will be 
mounted within the pod for example


		apiVersion: v1
		kind: Pod
		metadata:
		  name: mypod
		spec:
		  containers:
		  - image: alpine
		    name: alpine
		    command: ["/bin/sh". "-c"]
		    args: ["shuf -i 0-100 -n 1 >> /opt/number.out;"]
		    volumeMounts:
		    - mountPath: /opt
		      name: data-volume
		  volumes:
		  - name: data-volume
		    hostPath:
		      path: /data
		      type: Directory


its applicable when we have 1 node cluster in 3 node cluster at each node data stores
on every node /data they are infect not the same ...

for that solution there are multipule ways like NFS,GlusterFs,Flocker,ceph,scaleio ,aws
google cloud etc 

for example we can use aws (elastic block storage) as storage volume ....

		volumes:
		- name: data-volume
		  awsElasticBlockStore:
		    volumeID: <volume-id>
		    fsType: ext4 

now storage of pod will be on ebs on aws............

--------------------------------------------------------------------------------------

		Persistent Volumes

persistent volume is like a pool of storage which have created by the admnistrator and
the user who deploying pod can take some amount of storage from it ...

for creating Persistent Volume you can use presistent volume defination yaml file

		apiVersion: v1
		kind: PersistentVolume
		meatadata:
	          name: pv-vol1                
                spec:
		  accessModes:
		    - ReadWriteOnce
                  capacity:
                    storage: 1Gi
		  hostPath:
                    path: /tmp/data

here hostPath is not recomended for  production envirnoment .....

access Modes could be ReadOnlyMany, ReadWriteOnce, ReadWriteMany

run
	$ kubectl create -f pv-defination.yaml
	$ kubectl get persistentvolume


so you can use aws storage for storing data by this yaml

		apiVersion: v1
                kind: PersistentVolume
                meatadata:
                  name: pv-vol1 
                spec:
                  accessModes:
                    - ReadWriteOnce
                  capacity:
                    storage: 1Gi
                  awsElasticBlockStore:
		    volumeID: <volume-id>
		    fsType: ext4

-----------------------------------------------------------------------------------



		Persistent Volume Claim

persistent volume claim is used to claim storage for the node from the persistent 
volume, persistent volume and persistent volume claim are two diffrent objects in 
k8s , administrator create persistent volume and user can claim the storage from
the persistent volume created with object persistent volume claim........

we can create pvc by pvc defination yaml file for example

		apiVersion: v1
		kind: PersistentVolumeClaim
		metadata:
		  name: myclaim
		spec:
		  accessModes:
		    - ReadWriteOnce

		  resources:
		    requests:
		      storage: 500Mi


when we created pvc it looks for persistent volume which created by administrator and
when maches accessmode it claims the volume frome the persistent volume and bound to 
claim volume from pv since another pv created.....

you can delete pvc by 

	$ kubectl delete persistenvolumeclaim myclaim

you can choose what will be happend with volume so you can mention what you want

	persistenVolumeReclaimPolicy: Retain

by default it will be Retain it mean when pvc delete it will retain until manualy deleted
by the administrator 

	persistenVolumeReclaimPolicy: Delete

in this case pvc delete when we delete pvc...

	persistenVolumeReclaimPolicy: Recycle

data in the data volume will be  sucrupt making it available to other claims 




------------------------------------------------------------------

once you create a PVC use it in a Pod defination yaml file by specifying the pvc claim
name under persistenvolumeclaim section in the volumes section like this:

	apiVersion: v1
	kind: Pod
	metadata:
	  name: mypod
	spec:
	  containers:
	    - name: myfrontend
	      image: nginx
              volumeMounts:
              - mountPath: "/var/www/html"
                name: my-vol
          volumes:
	    - name: my-vol
              persistentVolumeClaim:
                claimName: myclaim
              
	for more help you can visit https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes
