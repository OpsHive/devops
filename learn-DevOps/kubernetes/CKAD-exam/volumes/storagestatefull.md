		storage in statefull sets 

so here we know that in k8s deployment when we use storage we have to create pv first
and then pvc to claim that pv and then use in pod at 

volumes:
- name: data-volume
  persistentVolumeClaim:
    claimName: data-volume

so in case of statefull set every instance of mysql need thier own pvc to store every 
mysql pod data(for example mysql-0 pod need pvc, and then mysql-1 pod need pvc, and mysql-2
need pvc) so every pvc need pv,, so how to create automaticaly pvc for every pod....?

you can achive that with volume claim template so you can mention all of your requiremtns
in statefull set

for example

apiVersion: apps/v1
kind: StatefullSet
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql
        volumeMounts:
        - mountPath: /var/lib/mysql
          name: data-volume
volumeClaimTemplates:
- metadata:
    name: data-volume
  spec:
    accessModes:
      - ReadWriteOnce
    storageClassName: google-storage
    resources:
      requests:
        storage: 500Mi


so volumeClaimTemplates is array so you can define more than one templates

sc-deffination yaml file 

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: google-storage
provisioner: kubernetes.io/qce-pd


so when pod created it create pvc from the template and storage class create volume on
disck and bound it to pv and pvc claim from the pv ,,when every time pod created it 
repeat the whole cycle again.....so if any pod deleted the volume will remain on storage
class and it wait for a new pod will be again bind to this volume.........
