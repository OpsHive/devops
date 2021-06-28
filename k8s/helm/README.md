https://www.arthurkoziel.com/private-helm-repo-with-gcs-and-github-actions/


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