		Replication Controller

replication controller and replicaset are diffrents a little bit replication controller is
old version of replica set so main diffrence is apiversion and shown in following example.
and another diffrence is , replicaSet use selector which must be mentioned in case of
replicaset but you can avoid in replication controller......



apiVersion: v1
kind: ReplicationController
metadata:
  name: myapp-rc
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
      - name: nginx-controller
        image: nginx
  replicas: 2


-------------------
		Replica set

apiVersion: apps/v1
kind: ReplicaSet
meatadata:
  name: myapp-nginx
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
      - name: nginx-container
        image: nginx
  replicas: 3
  selector:
    matchLabels:
      type: front-end



