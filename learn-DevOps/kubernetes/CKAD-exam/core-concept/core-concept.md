
    	core concept of kubernetes

kubernetes architecture

  - Node(Minions):
      node is a machine where kubernetes is installed on node.
  - cluster:
 	cluster is set of nodes grouped togather so multipule nodes combine togather
   	for running containers is called cluster.
      Master-node:
        who is responsible to managing cluster, and actual orchestrations of containers
        on worker-nodes
        components of master-node:
          -kube-apiServer
		act as frontend of k8s cluster, users,management devices, commandline interfaces all talk to apiserver to intract with k8s cluster.
          - sechduler:
 		is responsible for distributed workloads of container accross multiplule nodes . it looks newly created contianers and assign them to a node 
          - etcd:
		distributed key-value store, cluster used etcd to store data in distributed maner it has all informations about worker and master nodes seprately .
          - controller:
		is brain behinde orchestration they are responsible for noticeing and responding when node containes and endpoints goes down, controller make dissions to bring up contianers in such cases  
          - containerRuntime
		its like software like docker which used to run application in assolated environment.
          - kubelet:
		is an agent which runs on each nodes within the cluster, agents is responsible for making sure that the contianers runnings on the node as expected
  - kubectl:

  	kubectl used to deploy components of k8s on cluster
