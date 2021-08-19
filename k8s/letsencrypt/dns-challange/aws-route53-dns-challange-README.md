https://voyagermesh.com/docs/v12.0.0/guides/cert-manager/dns01_challenge/aws-route53/

1. Go to IAM page and create a user with name dns-challenge

2. Add user -> programatic accesss -> attach existing policy directly -> create policy

```

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ChangeResourceRecordSets",
      "Resource": "arn:aws:route53:::hostedzone/*"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZonesByName",
      "Resource": "*"
    }
  ]
}



```

Now click on json and paste this and click Review Policy

3. Name the policy "dns-challenge-policy" and create

4. navigate to previous window where you was creating user now refresh the listing of policy and 
  search for newly created dns-challange-policy which you create in previous step

5. select this policy and create user 

6. download accesskeyid and secret key .csv

7. Create a secret with the Secret Access Key

```

kubectl create secret generic route53-secret --from-literal=secret-access-key="skjdflk4598sf/dkfj490jdfg/dlfjk59lkj"

```

8. now you can create your issuer.yaml

```
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-prod
  namespace: default
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: envoyfacilitation@gmail.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: example-issuer-account-key
    solvers:
      - dns01:
          route53:
            region: us-east-2
            accessKeyID: AKIAZAOQNATECSP4KCEI
            secretAccessKeySecretRef:
              name: route53-secret
              key: secret-access-key
            hostedZoneID: Z08733612W15SDUOAEUGQ
```
9. create your ingress

````
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress-deploy-k8s-route53-dns
  namespace: default
  annotations:
    kubernetes.io/ingress.class: voyager
    certmanager.k8s.io/issuer: "letsencrypt-staging-dns"
    certmanager.k8s.io/acme-challenge-type: dns01
spec:
  tls:
    - hosts:
        - kiteci-route53-dns.appscode.me
      secretName: kiteci-route53-dns-tls
  rules:
    - host: kiteci-route53-dns.appscode.me
      http:
        paths:
          - backend:
              serviceName: web
              servicePort: 80
            path: /
```
10. now you can apply  your certificates.yaml

```
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-prod
  namespace: default
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: envoyfacilitation@gmail.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: example-issuer-account-key
    solvers:
      - dns01:
          route53:
            region: us-east-2
            accessKeyID: AKIAZAOQNATECSP4KCEI
            secretAccessKeySecretRef:
              name: route53-secret
              key: secret-access-key
            hostedZoneID: Z08733612W15SDUOAEUGQ

```

