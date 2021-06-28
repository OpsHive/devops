		statefull sets in k8s 

why we need Statefull Sets in K8s other than deployments.......?


so for example we need to deploy data base server not on k8s cluster but for simple
hosting plateforms so we need to setup virtual private server for data base mysql
so we have setup and other application use this database server so now we need to high
availablity of this server so we need need to  create 2 more  server of mysql we have 
black data base on new servers so how do we replicate the data on these servers from the
orignal data base server so how we can replicate data ....
so there are many topologies availble for this pupose we use master and slave in which 
main server will be Master and we configure it with slave1 so slave1 copy data from the 
Master each time master recived entry on Master node so in this way master must be created
first and then slave1 and after that slave2 so when slave1 copy the data from the Master
slave2 created after slave 1 so slave 2 copy data from slave1 on it....and finaly we 
enable continous replication in this order ....




so these points are really important to achive our desire state.....!!


1.setup master first and then slaves

2.clone data from the master to slave-1

3.enable continous replication from master to slave-1

4.wait for slave-1 to be ready

5.clone data from slave-1 to slave-2

6.Enable continous replication from master to slave-2

7.configure Master address on slave 




above is senerio and we want to  deploy this in k8s so if we deploy this in deployments
we cant achive our above 6 points desire state because we unable to create master and 
slave and configure master address on slave due to pod can be delete and created new one
so the ips would be changed with new pods we need here static host names, in deploymets
pods comming with thier dynamic names.so remain other points also cant achived so 
here statefull sets commes in


----------------------------------------------------------------------------------




		statefull sets

statefull sets similar to deployments  as they create pods, base on template, they can
scale up ,scaledown, they can perform updates , rollbacks, but there are some diffrences

in statefull sets pod will be created in sequensional order, after the first pod deployed
it must be in running and ready state for the next pod deployed so that is ensure
master has deployed first and then slave-1 and slave-2 so that helps us with point 1 and 
point 4 .,.,,,, statefull set asign unique orignal index to each pod its start index from
0 to 1,2,3 and so on. so each pod name drived from statefull name and  with index,  for
example first pod with mysql-0,second will be mysql-1 , third will mysql-2 and so on.....

so now if any pod delete and k8s create new one it will come up with same name so every
time master will be mysql-0 so statefull set help us in that senerio ....

  
-----------------------------------------------------------------------------------



	How to create statefull sets and configure ?

not every time you need to create statefull set in some case it would be best
option to create its template is same as deployment only change kind with statefullset
and need headless service at spec.serviceName: (service name is headless service Reffer
to headlessServiceREADME.md)

for example you can create with statefullset defination yaml file 


apiVersion: apps/v1
kind: StatefullSet
metadata:
  name: mysql
  labels:
    app : mysql
spec:
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql
  replicas:3
  selector:
    matchLabels:
      app: mysql
  serviceName: mysql-h
  


so after that run command 


	$ kubectl create -f statefullset-defination.yaml

it creates Ordered, gracefull deployment unique dns record which can any application
on the network can use best for setup database sultions......

so in defualt statefull set create pod with ordered but if you dont want ordered pod
you can overide with podManagementPolicy: Parallel at serviceName: mysql-h level

for example 

apiVersion: apps/v1
kind: StatefullSet
metadata:
  name: mysql
  labels:
    app : mysql
spec:
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql
  replicas:3
  selector:
    matchLabels:
      app: mysql
  serviceName: mysql-h
  podManagementPolicy: Parllel









