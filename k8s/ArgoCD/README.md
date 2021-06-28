
## setup Argocd
### Install Argo CD

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

```
### Argocd cli
Download the latest Argo CD version from https://github.com/argoproj/argo-cd/releases/latest. More detailed installation instructions can be found via the CLI installation documentation.

Download argocd cli from 

```
https://github.com/argoproj/argo-cd/releases/latest

```
### Access The Argo CD API Server

By default, the Argo CD API server is not exposed with an external IP. To access the API server, choose one of the following techniques to expose the Argo CD API server:

1. Service Type Load Balancer
Change the argocd-server service type to LoadBalancer:

```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

```

2. Ingress
Follow the ingress documentation on how to configure Argo CD with ingress.

3. Port Forwarding

Kubectl port-forwarding can also be used to connect to the API server without exposing the service.

```
kubectl port-forward svc/argocd-server -n argocd 8080:443

```
The API server can then be accessed using the localhost:8080

# for gke we need to open nodeport over firewall ruls

```
gcloud compute firewall-rules create argocd-Nodeport  --allow tcp:portNumber

```

### Login Using The CLI

Depending on the Argo CD version you are installing, the method how to get the initial password for the admin user is different.

## Argo CD 1.8 and earlier:

```
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

```

Using the username admin and the password from above, login to Argo CD's IP or hostname:

```
argocd login http://localhost:8080 
```
if you exposed argocd as Nodeport or Loadbalncer you can replace ip and nodeport with http://localhost:8080

After you can provide credentials

```
username: admin
password: <which you get with step 1 >

```


Change the password using the command:

```
argocd account update-password

```

## Argo CD v1.9 and later

The initial password for the admin account is auto-generated and stored as clear text in the field password in a secret named argocd-initial-admin-secret in your Argo CD installation namespace. You can simply retrieve this password using kubectl:

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

```

## Create An Application From A Git Repository

this repository must contains helm or your yaml file

## Creating Apps Via CLI
### add private repository on argocd

```
argocd repo add https://qasim-aziz@bitbucket.org/qasim683/changdra-react-app.git --username qasim-aziz --password YNr88t3VRSybUNNQqC6A

```
Check if this command added repository

```
argocd repo list

```


You can access Argo CD using port forwarding: add --port-forward-namespace argocd flag to every CLI command or set ARGOCD_OPTS environment variable: export ARGOCD_OPTS='--port-forward-namespace argocd':

```
argocd app create guestbook --repo https://qasim-aziz@bitbucket.org/qasim683/changdra-react-app.git --path helm-charts --dest-server https://kubernetes.default.svc --dest-namespace default

```
here is --repo is your git repository and, --path is your repository folder which holds yaml.
### create app with helm

```
argocd app create react-guestbook --repo https://qasim-aziz@bitbucket.org/qasim683/changdra-react-app.git --path helm-charts/react-app --dest-namespace default --dest-server https://kubernetes.default.svc

```


### Sync (Deploy) The Application

Once the guestbook application is created, you can now view its status:


```
$ argocd app get guestbook
Name:               guestbook
Server:             https://kubernetes.default.svc
Namespace:          default
URL:                https://10.97.164.88/applications/guestbook
Repo:               https://github.com/argoproj/argocd-example-apps.git
Target:
Path:               guestbook
Sync Policy:        <none>
Sync Status:        OutOfSync from  (1ff8a67)
Health Status:      Missing

GROUP  KIND        NAMESPACE  NAME          STATUS     HEALTH
apps   Deployment  default    guestbook-ui  OutOfSync  Missing
       Service     default    guestbook-ui  OutOfSync  Missing

```

The application status is initially in OutOfSync state since the application has yet to be deployed, and no Kubernetes resources have been created. To sync (deploy) the application, run:

```
argocd app sync guestbook

```