# Bitbucket Pipelines Demo and syntax 

## Triggers pipeline on branches
for more information https://support.atlassian.com/bitbucket-cloud/docs/pipeline-triggers/
Default branches: Contains the pipeline definition for all branches that don't match a pipeline definition in other sections. The default pipeline runs on every push to the repository unless a branch-specific pipeline is defined. You can define a branch pipeline in the branches section.

```
image: node:10.15.0
pipelines:
  default:
    - step:
        script:
          - echo "This script runs on all branches that don't have any specific pipeline assigned in 'branches'."
  branches:
    master:
      - step:
          script:
            - echo "This script runs only on commit to the master branch."
    feature/*:
      - step:
          image: openjdk:8 # This step uses its own image
          script:
            - echo "This script runs only on commit to branches with names that match the feature/* pattern."
```

## Gke deployments
for more information https://dev.to/jurriaanpro/spielerei-with-bitbucket-pipelines-and-kubernetes-16d1

create bitbucket pipeline workflow file  at root of repository with name of bitbucket-pipelines.yml

### node application example

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

this is example of node-app so we use node image, you can change it according to your requirements.

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
            - gcloud container clusters get-credentials $K8s_CLUSTER_NAME --zone=$GCLOUD_ZONE --project $GCLOUD_PROJECT_ID
    # DEPLOYMENT
            - kubectl set image deployment $K8s_DEPLOYMENT_NAME $K8s_DEPLOYMENT_NAME=$DOCKER_GCR_REPO_URL/$GCLOUD_PROJECT_ID/$DOCKER_IMAGE_NAME:${BITBUCKET_COMMIT} --record --namespace=$K8s_NAMESPACE
```

