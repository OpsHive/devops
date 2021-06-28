		Storage Classes

in this case we create google cloude persistent disk so before creating pv you have
to create google cloud pv disk

	$ gcloud beta compute disks create --size 1GB --region us-east1 pd-disk

and then you have to create pv with the same name with you have created disk

apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol1
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 500Mi
  gcePersistenDisk:
    pdName: pd-disk
    fsType: ext4


its called static Provisioning volumes..........

it would be nice if the volumes provision automatically when the application requires it
and that's where storage classes comes in ,,with storage classes you can dynamic provision
volumes so when ever required persistent volume claim created it can automaticaly provision
on google persistent disk .you can create this with storage classes defination yaml file.

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: google-storage
provisioner: kubernetes.io/gce-pd

so now we have storage class so no longer need of pv because pv is already created by 
the google gce storage as pv  .......

soo now when we have to create pvc use storageClassName which you have created perviously

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: google-storage
  resources:
    requests:
      storage: 500Mi

so now you can use this pvc in the pod at volumes section



volumes:
  - name: data-volume
    persistentVolumeClaim:
      claimName: myclaim


-----------------------------------------------------------------------------

until we have created gce pv there are many other provsionrs as well such as aws,azure
azureDisk, cephFS, clinder,FC,FlexVolume,Flocker,GCEPpersistentDisk,Glusterfs,SCSI,Quobyte,
NFS,RBD, etc......

for google gce provision storage with other perameters. and with other all provsioners
you can define more perameters like disk type repliation type etc these are very specificc
with provisioners which you are using ..with gce you can define type pd-standard or 
pd-standard or pd-ssd, and replication-type could be none or regional-pd, there are 
multipule stoage classes like silver with pd-standard, gold with pdd-ssd, and platinum
with pd-ssd and replication regional-pd

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: google-storage
provisioner: Kubernetes.io/gce-pd
parameters:
  type: pd-standard
  replication-type: none

