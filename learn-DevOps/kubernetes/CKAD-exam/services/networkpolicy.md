		Network Policy
                --------------

by default ingresss and egress traffic allow from any pod to pod communication if you really want
to restrict traiffic from one pod to another you can create network policy and attached to the pod
by label selector.in network policy there are several rules which apply according to ingress
or egress trafic


apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-policy
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: api-pod
    ports:
    - protocol: TCP
      port: 3306

---------------------------------------------------------------------

Note:

solutions that support network policies:
* kube-router
*calico
*romana
*weave-net

solutions that DO NOT Support Network Policies:

* Flannel

--------------------------------------------

egress:- sernerio is accepting trafic from internal application to payroll and mysql...

-------

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-policy
spec:
  podSelector:
    matchLabels:
      name: internal 
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - {}
  egress:
  - to:
    - podSelector:
        matchLabels:
          name: mysql
    ports:
    - protocol: TCP
      port: 3306
  - to:
    - podSelector:
        matchLabels:
          name: payroll
    ports:
    - protocol: TCP
      port: 8080
