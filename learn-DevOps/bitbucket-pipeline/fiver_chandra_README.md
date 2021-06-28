# requirements for the Project

## CI/CD requirements:
- :heavy_check_mark: 1. Create Bitbucket actions (similar to Git actions)
- :heavy_check_mark: 2. Evaluate the possibility to spin up a hosted runner in Bitbucket
- :heavy_check_mark: 3. Should be able to do CI, CD and Deploy using Bitbucket actions with ArgoCD
- :heavy_check_mark: 4.(a) Create a sample GKE project with helm charts, 
- :heavy_check_mark: 4.(b) should be able to build, deploy using helm charts in IAC (Infrastructure as Code) model

----------------------------------------------------------------------------------------------------------

# 1. Create Bitbucket actions (similar to Git actions)
### bitbucket-pipeline
before moving over pipeline we need to setup pipeline variable, which we use in workflow file. variables use to secure pipline and we dont want to 
expose our credentials over pipeline.

```
GCLOUD_API_KEYFILE        json_keyfile content 
DOCKER_GCR_REPO_URL       eu.gcr.io
GCLOUD_PROJECT_ID         gcp project id
DOCKER_IMAGE_NAME         your app image name
k8s_CLUSTER_NAME          cluster name
GCLOUD_ZONE               zone 

```
## demo pipeline

```
image: node:10.15.0


pipelines:

  branches:

    master:
        - step:
            name: Run NPM Install
            caches:
            - node
            script: 
            - npm install
        - step:
            name: Run Node Tests
            caches:
            - node
            script:
            - npm test
            
        - step:
            name: Build and Push Docker Image
            image: google/cloud-sdk:latest
            script:
            - echo $GCLOUD_API_KEYFILE > ~/.gcloud-api-key.json
            - gcloud auth activate-service-account --key-file ~/.gcloud-api-key.json
            - docker login -u _json_key --password-stdin https://$DOCKER_GCR_REPO_URL < ~/.gcloud-api-key.json
            - docker build -t $DOCKER_IMAGE_NAME:${BITBUCKET_COMMIT} .
            - docker tag $DOCKER_IMAGE_NAME:${BITBUCKET_COMMIT} $DOCKER_GCR_REPO_URL/$GCLOUD_PROJECT_ID/$DOCKER_IMAGE_NAME:${BITBUCKET_COMMIT}
            - docker push $DOCKER_GCR_REPO_URL/$GCLOUD_PROJECT_ID/$DOCKER_IMAGE_NAME:${BITBUCKET_COMMIT}
```


# 2. Evaluate the possibility to spin up a hosted runner in Bitbucket

## Bitbucket self hosted runners

1. go on repository settings
2. click on Runner
3. create Runner
4. provide name
5. copy command and past on your command line

```
docker container run -it -v /tmp:/tmp -v /varun/docker.sock:/var/run/docker.sock -v /var/lib/docker/containers:/var/lib/docker/containers:ro -e ACCOUNT_UUID={329c38a5-d32c-432d-a87c-73e344430d33} -e REPOSITORY_UUID={a0f03b24-a38a-447f-9da0-1b7e498f96ce} -e RUNNER_UUID={bc000071-e974-58d7-8745-c37294a4d85f} -e OAUTH_CLIENT_ID=w7r18Hwhq5xVDiEFDH4bniR5l7xLQbCb -e OAUTH_CLIENT_SECRET=Imt0JpFfBdPV02D1Nr86krH4h5m897t89yI_HVa-wokwaTVpTIhoY_9s7O9wVRim -e WORKING_DIRECTORY=/tmp --name runner docker-public.packages.atlassian.com/sox/atlassian/bitbucket-pipelines-runner

```



6. add snipt over pipeline under script tag.

for example 

```
- step:
    runs-on: self.hosted
    name: Run NPM Install
    caches:
    - node
    script: 
    - npm i
    - npm i @material-ui/icons
    - npm i @material-ui/core

```
-------------------------------------------------------------------------------------------------------------------------------

# 3. Should be able to do CI, CD and Deploy using Bitbucket actions with ArgoCD

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
# 4.(a) Create a sample GKE project with helm charts

you can package you application with helm

## download and install helm 

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh


```
## how to use helm 


```
helm add repo gs:/qasim-helm-charts private
helm repo update
helm search repo private
helm install react-app --version 0.1.0 --generate-name


```


# 4.(b) should be able to build, deploy using helm charts in IAC (Infrastructure as Code) model

## Terraforms
installation:
Download the terraform binary for your platform
```
https://www.terraform.io/downloads.html

```
for linux navigate to Download folder and give excuteable permissions


```
# permissions
sudo chmod +x ./terraform_0.15.5_linux_amd64.zip

#unzip downloaded file
unzip ./terraform_0.15.5_linux_amd64.zip

# copy terraform binary on shell

cp ./terraform /usr/local/bin

```
you can build your gcp resource with iac tool terraforms 

create gke cluster with terraforms
create providers.tf for google
nano providers.tf
```
provider "google" {
  # version     = "2.7.0"
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}


```
nano main.tf

```

resource "google_container_cluster" "primary" {
  name               = var.cluster
  location           = var.zone
  initial_node_count = 3

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }



  timeouts {
    create = "30m"
    update = "40m"
  }
}

```
nano variables.tf

```
variable "project" {
  default = "qbitflames"
}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-d"
}

variable "cluster" {
  default = "qbit-dev"
}

variable "credentials" {
  default = "~/dev/fiver/chandra/changdra-react-app/terraform/gke-cluster-module/creds/service-account.json"
}

variable "kubernetes_min_ver" {
  default = "latest"
}

variable "kubernetes_max_ver" {
  default = "latest"
}

```
nano output.tf

```
output "cluster" {
  value = google_container_cluster.primary.name
}

output "host" {
  value     = google_container_cluster.primary.endpoint
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  sensitive = true
}

output "username" {
  value     = google_container_cluster.primary.master_auth.0.username
  sensitive = true
}

output "password" {
  value     = google_container_cluster.primary.master_auth.0.password
  sensitive = true
}
```

after creating these file you just need to create service account and give them permissions of editor and download service-account.json key file and give path in variables.tf affter that you can create resources 

```
terraform init
terraform plan
terraform apply
terraform destroy

```