# setup nginx-contorller and enable tls

## setup nginx-controller 

1. with plane yamls

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/do/deploy.yaml
```


2. with helm

```
# added and update helm repository 

helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update

# install:

helm install nginx-ingress nginx-stable/nginx-ingress

# check installation:

kubectl get deployment nginx-ingress-nginx-ingress
kubectl get service nginx-ingress-nginx-ingress

```

## Installing and Configuring Cert-Manager


```
# installation:

kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.16.1/cert-manager.yaml

# check installation 

kubectl get pods --namespace cert-manager

```

## Create Cluster issuers

### staging cluster-issuer

save this menifest as yaml file and apply with

    $ kubectl create -f staging_issuer.yaml


```
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
 name: letsencrypt-staging
 namespace: cert-manager
spec:
 acme:
   # The ACME server URL
   server: https://acme-staging-v02.api.letsencrypt.org/directory
   # Email address used for ACME registration
   email: your_email_address_here
   # Name of a secret used to store the ACME account private key
   privateKeySecretRef:
     name: letsencrypt-staging
   # Enable the HTTP-01 challenge provider
   solvers:
   - http01:
       ingress:
         class:  nginx
```
out put will be 

    clusterissuer.cert-manager.io/letsencrypt-staging created

### prod cluster-issuer

save this menifest as yaml file and apply with

    $ kubectl create -f prod_issuer.yaml


```
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: your_email_address_here
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class: nginx
```
out put will be 

    clusterissuer.cert-manager.io/letsencrypt-prod created

## edit your nginx-ingress service and set hostname 

Now that you’ve created a DNS record pointing to the Ingress load balancer, annotate the Ingress LoadBalancer Service with the do-loadbalancer-hostname annotation. Open a file named ingress_nginx_svc.yaml in your favorite editor and paste in the following LoadBalancer manifest:

```
apiVersion: v1
kind: Service
metadata:
  annotations:
    service.beta.kubernetes.io/do-loadbalancer-enable-proxy-protocol: 'true'
    service.beta.kubernetes.io/do-loadbalancer-hostname: "dev.example.com"
  labels:
    helm.sh/chart: ingress-nginx-2.11.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.34.1
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  type: LoadBalancer
  externalTrafficPolicy: Local
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: http
    - name: https
      port: 443
      protocol: TCP
      targetPort: https
  selector:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/component: controller

```




## setup ingress-resource 

# ingress-resource template for kubernetes  1.16 version to 1.19 version

```
cat <<EOF > ingress-resource.yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-resource
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - host: app.174.20.253.11.nip.io
    http:
      paths:
      - backend:
          serviceName: nginx
          servicePort: 80
        path: /
EOF
```
# ingress-ressource template for above kubernetes 1.19 to 1.21 version

```
cat <<EOF > ingress-resource.yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-resource
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  ingressClass: nginx
  rules:
  - host: app.174.20.253.11.nip.io
    http:
      paths:
      - backend:
          serviceName: nginx
          servicePort: 80
        path: /
EOF
```

## apply ingress resource for lets encrypt tls

update your ingress-resource menifest for applying lets-encrypt certificates 

# Staging-tls
first we apply stagging certificates becasue in prod we just have few attempts limits so first we can test it with staging.

```
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-resource
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-staging"
    acme.cert-manager.io/http01-edit-in-place: "true"
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - dev.example.com
    secretName: dev-tls
  rules:
  - host: app.174.20.253.11.nip.io
    http:
      paths:
      - backend:
          serviceName: nginx
          servicePort: 80
        path: /
```

we can verify it by

    $ kubectl describe ingress
    $ kubectl describe certificate

# prod-tls

apply changes for prod tls with this template

```
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-resource
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    acme.cert-manager.io/http01-edit-in-place: "true"
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - dev.example.com
    secretName: dev-tls
  rules:
  - host: app.174.20.253.11.nip.io
    http:
      paths:
      - backend:
          serviceName: nginx
          servicePort: 80
        path: /
```

we can verify it by 

    $ kubectl describe certificate dev-tls

## if you already have certificates 

if you have certificates you can create secret and with this template

```
apiVersion: v1
data:
  ca.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURJVENDQWdt
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURJVENDQWdtZ0F3SUJBZ0lSQUx4a0t6ZUZmalNudy8xZU12dEpGUkl3RFFZSktvWklodmNOQVFFTEJRQXcK
  tls.key: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBMVVTTTFlN2MxCkJtRmpISFp2dnk0Nm1OcHJrK0VtTjNTSEpIc
kind: Secret
metadata:
  name: example-tls
  namespace: default
type: kubernetes.io/tls

```

you can also convert your file as base64 with 

    $ cat ca.cert | base64
    $ cat tls.cert | base64
    $ cat tls.key | base64

---------------------------------End--------------------------