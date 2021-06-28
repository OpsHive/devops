# Self Signed certificates for kubernetes Cluster

## Create a Kubernetes in Docker Cluster

You’ll need a Kubernetes cluster, we’re not doing anything too resource intensive so a k3d cluster should be fine.

```
k3d cluster create dev-cluster --agents 2

```

test the cluster 

    $ kubectl cluster-info


## Creating self signed certificates with cert-manager

install cert-manager

```
kubectl create namespace cert-manager

kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.13.1/cert-manager.yaml

```
If you receive a validation error relating to the x-kubernetes-preserve-unknown-fields add --validate to the above command and run again.

### create a namespace to work in:

    $ kubectl create namespace sandbox

## create an issuer:
Note: you can create a ClusterIssuer instead if you want to be able to request certificates from any namespace.
```
kubectl apply -n sandbox -f <(echo "
apiVersion: cert-manager.io/v1alpha2
kind: Issuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
")
```

## Create a self signed certificate:

This creates a wildcard certificate that could be used for any services in the sandbox namespace.

```
kubectl apply -n sandbox -f <(echo '
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: first-tls
spec:
  secretName: first-tls
  dnsNames:
  - "*.sandbox.svc.cluster.local"
  - "*.sandbox"
  issuerRef:
    name: selfsigned-issuer
')
```
### Validate the secret is created
Check the certificate resource:
```
$ kubectl -n sandbox get certificate
  NAME        READY   SECRET      AGE
  first-tls   True    first-tls   9s
```
### check the subsequent secret:

```
$ kubectl -n sandbox get secret first-tls
NAME        TYPE                DATA   AGE
first-tls   kubernetes.io/tls   3      73s
```
This secret contains three keys ca.crt, tls.crt, tls.key. You can run kubectl -n sandbox get secret first-tls -o yaml to see the whole thing.

### Test that the certificate is valid:

```
openssl x509 -in <(kubectl -n sandbox get secret \
  first-tls -o jsonpath='{.data.tls\.crt}' | base64 -d) \
  -text -noout
```

If you scan through the output you should find X509v3 Subject Alternative Name: DNS:*.first.svc.cluster.local, DNS:*.first.

Congratulations. You’ve just created your first self signed certificate with Kubernetes. While it involves more typing than docker run paulczar/omgwtfssl it is much more useful for Kubernetes enthusiasts to have the cluster generate them for you.

However, what if you want to use TLS certificates signed by the same CA for performing client/server authentication? Never fear we can do that too.


