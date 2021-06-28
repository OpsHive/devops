there are many open source monitoring tools for server matric we can get matrix
realted to node that how many resources available on the node like cpu memorty networking etc
as well as node we can also get pods matrics by some opensource tools like ..

*metrics-server
*prometheus
*elasticstack
*datadog
*dynatrace

----------------------------------

for ckad-exam understaing we need to know metrics-server

heapster vs matrics server

heapster now depreceated and only matrics server is available

matrics-server
-------------
  it only collect and store matrics in in-memory and not store on disk. so in this case
you can not view historical data of cluster matrics but for solution you can use some other
opensource tools ....

in server matircs >

 as we know on every node we have a kubelet running and kubelet component cAdvisor . cAdvisor
is responsible to retrive prformance matrics from pod and expose them kubelet api.

minikube:

 $ kubectl adddons enable metrics server

for others:

 $ git clone https://github.com/kubernetes-incubator/metrics-server.git

or

 $ git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git


 $ kubectl create -f deploy/1.8/


-----------------

once setup metrics-server you can view by 

 $ kubectl top node

 $ kubectl top pod




