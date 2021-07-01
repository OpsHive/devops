# how to deploy nginx ingress contonroller for 1.19 version kubernetes .

1. create ingressClass.yaml and apply with following contect.

```
apiVersion: networking.k8s.io/v1beta1
kind: IngressClass
metadata:
  name: nginx
spec:
  controller: k8s.io/ingress-nginx

```

2. deploy nginx-ingress controller

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/aws/deploy.yaml

```
3. now create ingress resource

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wildcard-host
spec:
  ingressClassName: nginx
  rules:
  - host: test.neuman.nz
    http:
      paths:
      - pathType: Prefix
        path: /
        backend:
          service:
            name: cleo
            port:
              number: 80
  - host: test.neuman.nz
    http:
      paths:
      - pathType: Prefix
        path: /
        backend:
          service:
            name: cleo
            port:
              number: 80
  - host: test.neuman.nz
    http:
      paths:
      - pathType: Prefix
        path: /
        backend:
          service:
            name: cleo
            port:
              number: 80

```
