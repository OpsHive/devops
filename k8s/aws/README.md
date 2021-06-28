# setup aws eks cluster with auto-scaling

create user and provide permission "AdmnistratorAccess"

create access_keys and configure your aws cli with keys and zone

## create cluster with asg-mangednodes
you can change your --name with your own cluster name.

```
eksctl create cluster --name neuman-cluster --version 1.19 --managed --asg-access

```

## deploy cluster auto scaler
1. Deploy the cluster autoscaler

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml

```
2. Patch the deployment to add the cluster-autoscaler.kubernetes.io/safe-to-evict annotation to the Cluster Autoscaler pods with the following command

```
kubectl patch deployment cluster-autoscaler \
  -n kube-system \
  -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'

```
3. Edit the Cluster Autoscaler deployment with the following command.

before edit you can set your default  editor=nano (optional)

export EDITOR=nano

```
kubectl -n kube-system edit deployment.apps/cluster-autoscaler

```
Edit the cluster-autoscaler container command to replace <YOUR CLUSTER NAME> (including <>) with the name of your cluster, and add the following options.

--balance-similar-node-groups

--skip-nodes-with-system-pods=false

```
    spec:
      containers:
      - command:
        - ./cluster-autoscaler
        - --v=4
        - --stderrthreshold=info
        - --cloud-provider=aws
        - --skip-nodes-with-local-storage=false
        - --expander=least-waste
        - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/<YOUR CLUSTER NAME>
        - --balance-similar-node-groups
        - --skip-nodes-with-system-pods=false

```
4. Open the Cluster Autoscaler releases page from GitHub https://github.com/kubernetes/autoscaler/releases in a web browser and find the latest Cluster Autoscaler version that matches the Kubernetes major and minor version of your cluster. For example, if the Kubernetes version of your cluster is 1.20, find the latest Cluster Autoscaler release that begins with 1.20. Record the semantic version number (1.20.n) for that release to use in the next step.

5. Set the Cluster Autoscaler image tag to the version that you recorded in the previous step with the following command. Replace 1.20.n with your own value.

```
kubectl set image deployment cluster-autoscaler \
  -n kube-system \
  cluster-autoscaler=k8s.gcr.io/autoscaling/cluster-autoscaler:v1.19.1

```
## View your Cluster Autoscaler logs
After you have deployed the Cluster Autoscaler, you can view the logs and verify that it's monitoring your cluster load.

View your Cluster Autoscaler logs with the following command

```
kubectl -n kube-system logs -f deployment.apps/cluster-autoscaler

```
you will get logs like this...

```
I0628 09:11:59.927910       1 static_autoscaler.go:229] Starting main loop
I0628 09:11:59.928237       1 filter_out_schedulable.go:65] Filtering out schedulables
I0628 09:11:59.928254       1 filter_out_schedulable.go:132] Filtered out 0 pods using hints
I0628 09:11:59.928262       1 filter_out_schedulable.go:170] 0 pods were kept as unschedulable based on caching
I0628 09:11:59.928269       1 filter_out_schedulable.go:171] 0 pods marked as unschedulable can be scheduled.
I0628 09:11:59.928277       1 filter_out_schedulable.go:82] No schedulable pods
I0628 09:11:59.928295       1 static_autoscaler.go:402] No unschedulable pods
I0628 09:11:59.928308       1 static_autoscaler.go:449] Calculating unneeded nodes
I0628 09:11:59.928322       1 pre_filtering_processor.go:66] Skipping ip-192-168-2-21.us-east-2.compute.internal - node group min size reached
I0628 09:11:59.928330       1 pre_filtering_processor.go:66] Skipping ip-192-168-35-206.us-east-2.compute.internal - node group min size reached
I0628 09:11:59.928356       1 static_autoscaler.go:503] Scale down status: unneededOnly=true lastScaleUpTime=2021-06-28 09:09:09.413361771 +0000 UTC m=+36.631761087 lastScaleDownDeleteTime=2021-06-28 09:09:09.413361834 +0000 UTC m=+36.631761150 lastScaleDownFailTime=2021-06-28 09:09:09.413361902 +0000 UTC m=+36.631761216 scaleDownForbidden=false isDeleteInProgress=false scaleDownInCooldown=true
```

if you want to test then 

https://aws.amazon.com/premiumsupport/knowledge-center/eks-metrics-server-pod-autoscaler/

## Create a Kubernetes Metrics Server

To install Metrics Server, run the following command:

```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml


```

Create a php-apache deployment and a service

1.    To create a php-apache deployment, run the following command:

```
kubectl create deployment php-apache --image=k8s.gcr.io/hpa-example
```

2.    To set the CPU requests, run the following command:

```
kubectl patch deployment php-apache -p='{"spec":{"template":{"spec":{"containers":[{"name":"hpa-example","resources":{"requests":{"cpu":"500m"}}}]}}}}'

```
Important: If you don't set the value for cpu correctly, then the CPU utilization metric for the pod isn't defined and the HPA can't scale.

3.    To expose the deployment as a service, run the following command:
```
kubectl create service clusterip php-apache --tcp=80
```
4.    To create an HPA, run the following command:

```
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10

```
5.    To confirm that the HPA was created, run the following command.

```
kubectl get hpa
```
6.    To create a pod to connect to the deployment that you created earlier, run the following command:

```
kubectl run  -i --tty load-generator --image=busybox /bin/sh
```
7.    To test a load on the pod in the namespace that you used in step 1, run the following script:

```
while true; do wget -q -O- http://php-apache; done

```