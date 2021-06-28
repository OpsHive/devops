			Jobs in kubernetes

jobs in kuberentes is a running a job container for a specific time it done its job
and after that container will be completed state we use to perform verious task in jobs like 
getting logs,batch-proccessing, sending emails , for running migrations etc once completed pod will be die 
and go into completed state


apiVersion: v1
kind: Pod
metadata:
  name: math-pod
spec:
  containers:
  - name: math-add
    image: ubuntu
    command: ['expr', '3', '+', '2']
  restartPolicy: Never


----------------------------------------------

	how to create job menifest

apiVersion: batch/v1
kind: Job
metadata:
  name: math-add-job
spec:
  template:
    spec:
      containers:
      - name: math-add
        image: ubuntu
        command: ['expr', '3', '+', '2']
      restartPolicy: Never

---------------------------------------------------

you can create and delete job like other k8s objects


 $ kubectl apply -f job.yaml

 $ kubectl delete job my-job

-----------------------------------------------------

you can also run jobs with multipods like

apiVersion: batch/v1
kind: Job 
metadata:
  name: math-add-job
spec:

  completions: 3
  parallelism: 3

  template:
    spec:
      containers:
      - name: math-add
        image: ubuntu
        command: ['expr', '3', '+', '2']
      restartPolicy: Never


--------------------------------------------------------

when we define in jobs defination parallelism it will create pod pod until complete all 3
pods  

