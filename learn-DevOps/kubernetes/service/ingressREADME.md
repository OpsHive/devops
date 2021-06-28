		Ingress Controller


ingress controller is not available by default in kubernetes so you have to create
one of them for solution

	- gcp http(s) LoadBalancer(GCE)
	- nginx
	- contour
	- haproxy
	- traefik
	- Istio

gcp http(s) loadbalncer(gce) and nginx are supported by kubernetes 

nginx ingress controller is not loadbalncer and also not as nginx server its diffrent 
from them but in nginx ingress controller used loadbalncer intelligently 
nginx ingress controller deployed as just another deployment

now we will deploy it with deployment defination yaml

	apiVersion: extensions/v1beta1
	kind: Deployment
	metadata:
	  name: nginx-ingress-controller
	spec:
	  replicas: 1
	  selector:
	    matchLabels:
	      name: nginx-ingress
	  template:
	    metadata:
	      labels:
	        name: nginx-ingress
	    spec:
	      containers:
	        - name: nginx-ingress-controller
		  image: quay.io/kubernetes-ingress-
                         controller/nginx-ingress-controller:0.21.0
	      args:
	        - /nginx-ingress-controller
	        - --configmap=$(POD_NAMESPACE)/nginx-configuration
	      env:
	        - name: POD_NAME
	          valueFrom:
	            fieldRef:
		      fieldPath: metadata.name
                - name: POD_NAMESPACE
	          valueFrom:
                    fieldRef:
                      fieldPath: metadata.namespace
              ports:
                - name: http
                  containerPort: 80
                - name: https
                  containerPort: 443

-----------------------------------------------------------
now you have to create ingress service in yaml file

	apiVersion: v1
	kind: Service
	metadata:
	  name: nginx-ingress
        spec:
          type: NodePort
          ports:
          - port: 80
            targetPort: 80
            protocol: TCP
            name: http
          - port: 443
            targetport: 443
            protocol: TCP
            name: https
          selector:
            name: nginx-ingress

------------------------------------------------------------

if you want to modify configuration of nginx you can create another resource 
called ConfigMap and pass configuration by default you can use this yaml

	apiVersion: v1
	kind: ConfigMap
	meatadata:
	  name: nginx-configuration


--------------------------------------------

after that you have to create service account for roles ClusterRoles, RoleBindings
for auth

	apiVersion: v1
	kind: ServiceAccount
	metadata:
	  name: nginx-ingress-serviceaccount

-----------------------------------------------------------------------




so after creating ingress Controller you have to create ingress Resource with 
simple ingress-resource defination yaml

	apiVersion: extensions/v1beta1
	kind: Ingress
	metadata:
	  name: ingress-wear
	spec:
	  backend:
	    serviceName: wear-service
	    servicePort: 80


and then create it with kubectl create -f ingress-resource.yaml

you can route traffic on diffrent urls base on ruls so you can define rules in 
ingress defination yaml file .....(for example rule 1 is to send trafic on that pods
which are serving one application like www.my-online-store.com/wear and rule 2 should
be serving application like www.my-online-store.com/watch and so on .........

so we can create it ingress with rules with following yaml

	apiVersion: extensions/v1beta1
	kind: Ingress
	metadata:
	  name: ingress-wear-watch
	spec:
	  rules:
	  - http:
	      paths:
	      - path: /wear
	        backend:
		  serviceName: wear-service
		  servicePort: 80
	      - path: /watch
	        backend:
		  serviceName: watch-service
		  servicePort: 80


in another case were you have more then one host for example you have
wear.my-online-store.com and watch.my-online-store.com you can create it with
following yaml file 

	apiVersion: extensions/v1beta1
        kind: Ingress
        metadata:
          name: ingress-wear-watch
        spec:
	  rules:
	  - host: wear.my-online-store.com
	    http:
	      paths:
	      - backend:
	          serviceName: wear-service
	          servicePort: 80
	  - host: watch.my-online-store.com
	    http:
	      paths:
	      - backend:
		  serviceName: watch-service
		  servicePort: 80

----------------------------------------------------------------------------------------------------------

	apiVersion: extensions/v1beta1
        kind: Ingress
        metadata:
          name: test-ingress
          namespace: critical-space
          annotations:
            nginx.ingress.kubernetes.io/rewrite-target: /
	spec:
	  rules:
	  - http:
	      paths:
	      - path: /pay
		backend:
		  serviceName: pay-service
		  servicePort: 8282
	



