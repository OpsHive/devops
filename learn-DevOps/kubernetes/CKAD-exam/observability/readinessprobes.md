		Readiness Probes

readiness probes used to observe pod status it used to send traffic to the pod when its in ready
state 

there are many stages of life cycles of pod

pod status
-----------

pending
containercreating
running

--------------------------------------------------------------------------------




Pod conditions
-------------

PodScheduled      True | False

initialized       True | False

containersReady   True | False  (this is used to send traffic)

Ready             True | False

----------------------------

you can view these conditions

	$ kubectl describe pod
---------------------------------------------------------------------

you need to define readiness probes which first test the container with diffrent test if it is
in ready conditions then it send traffic to the container test may be 3 type 

*HTTP test - /api/ready
*TCP socket test
* excute command to chack status

	HOW TO DEFINE READINESS PROBES
       --------------------------------

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
    readinessProbe:
      httpGet:
        path: /api/ready
        port: 8080
      initialDelaySeconds: 10
      periodSeconds: 5
      failureThreshold: 8



(by defualt readiness probes run 3 time by failureThreshold you can specifi more
---------------------------------------------------------------------------

there are three types of test 

httpGet
-------

readinessProbe:
  httpGet:
    path: /api/ready
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
  failureThreshold: 8




---------------------------------------------------

tcpSocket
----------

readinessProbe:
  tcpSocket:
    port: 3306
  initialDelaySeconds: 10
  periodSeconds: 5
  failureThreshold: 8





--------------------------------------------------

exec
----

readinessProbe:
  exec:
    command:
    - cat
    - /api/is_ready
  initialDelaySeconds: 10
  periodSeconds: 5
  failureThreshold: 8



-------------------------------------------------


