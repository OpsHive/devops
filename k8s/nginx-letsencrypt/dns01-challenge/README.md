when deploy second ingress you just need to install it another namespace

edit the deployment and change ingress class into contianer command section

you need to edit role

```
kubectl -n default edit role

```

edit configmap and set according to our ingress class name which we have define in previous session.

now apply our ingress resource with ingressClassName: new-ingress 

------------------------------------

first apply dns01-challenge file in sequnce , apply first issuer.yaml then secret.yaml then certificate.yaml , after that your ingress-resource.
that's it.

# annotations

nginx.ingress.kubernetes.io/rewrite-target: /$2

this annotation used for when pod expoed on fabluent.com and after getting this url on browser pod generate fabluent.com/student/login , so student/login part comes from pod. on refresh it target should be fabluent.com but it show extera student/login. for manging this we rewrite-targets with this annotation , when we put this annotation on ingress-resource it will never through nginx error . 