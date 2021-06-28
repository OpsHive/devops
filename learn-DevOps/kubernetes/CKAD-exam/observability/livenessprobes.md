		liveness probes

liveness probes used to test container if inside process is running instead of only running
state of pod it check if containers is accutlly working or  servers its used so in k8s
we need to specifiy liveness test into container

apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-app
    image: nginx
    ports:
    - containerPort: 8080
    livenessProbe:
      httpGet:
        path: /api/healthy
        port: 8080

------------------------------------

httpGet
-------

livenessProbe:
  httpGet:
    path: /api/ready
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
  failureThreshold: 8




---------------------------------------------------

tcpSocket
----------

livenessProbe:
  tcpSocket:
    port: 3306
  initialDelaySeconds: 10
  periodSeconds: 5
  failureThreshold: 8





--------------------------------------------------

exec
----

livenessProbe:
  exec:
    command:
    - cat
    - /api/is_ready
  initialDelaySeconds: 10
  periodSeconds: 5
  failureThreshold: 8



-------------------------------------------------


