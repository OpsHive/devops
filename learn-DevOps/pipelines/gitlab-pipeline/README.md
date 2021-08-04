# example gitlab pipeline for k8s ci, image building, pathing deployment



```
image: docker:latest  
stages:
  - CI
  - docker-build
  - patch


CI:
  stage: CI
  image: node
  script: 
    - echo "Start npm install App"
    - npm install
    - echo "npm install successfully!"
  tags:
    - self-hosted


docker-build:
  stage: docker-build

  services: 
    - name: docker:dind    
  before_script:
    - docker login -u "flyme247" -p "Hamza0308@" "docker.io"
  script:
    - docker build -t "flyme247/dev-frontend":"$CI_COMMIT_SHA" .
    - docker push "flyme247/dev-frontend":"$CI_COMMIT_SHA"
    - echo "Registry image:" flyme247/dev-fronten:"$CI_COMMIT_SHA"
    - echo "testing"
  tags:
    - self-hosted

patch:
  stage: patch
  script:
    - |
      apk add git
      git clone -b dev https://argocd:hEzAxx1DNHDHVFy8Dm8M@git.flyme247.com/root/k8s-menifest.git
      ls
      cd k8s-menifest/frontend
      git config credential.helper store
      ls
      rm -f deployment.yaml   
      cat <<EOF >> deployment.yaml
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        creationTimestamp: null
        labels:
          app: frontend
        name: frontend
        namespace: dev
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: frontend
        strategy: {}
        template:
          metadata:
            creationTimestamp: null
            labels:
              app: frontend
          spec:
            containers:
            - image: docker.io/flyme247/dev-frontend:$CI_COMMIT_SHA
              name: frontend-app
              imagePullPolicy: Always
              envFrom:
              - configMapRef:
                  name: frontend-configmap
              - secretRef:
                  name: frontend-secret
              # resources:
              #   requests:
              #     memory: "64Mi"
              #     cpu: "250m"
              #   limits:
              #     memory: "128Mi"
              #     cpu: "500m"
            imagePullSecrets:
            - name: regcred
      EOF
      git config --global user.email "argocd@git.flyme247.com"
      git config --global user.name "argocd"
      git add .
      git commit -m "from pipeline "
      git push origin dev
  tags:
    - self-hosted  
```
