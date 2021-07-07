for vue ci image building and patch deployment

```
workflow.yaml 
name: prod fabluentfe continous integrations and image build 

on:
  push:
    branches:
    - prod/feature/devops

jobs:
  VUE-CI:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [12.x]
    
    steps:
    - uses: actions/checkout@v2

    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v1
      with:
        node-version: ${{ matrix.node-version }}
    - run: npm update 
    - run: npm i
    
  
  build-job:
    needs: [VUE-CI]
    if: success()
    name: Docker build
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Docker login
      env:
        DOCKER_USER: ${{ secrets.DOCKER_USERNAME }}
        DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }} 
        
        
      run: |
        docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
    - name: Docker build
      run: |
        docker build -t bazihassan/prod-fabluentfeapp:$GITHUB_SHA .
    - name: Docker push images
      run: |
        docker push docker.io/bazihassan/prod-fabluentfeapp:$GITHUB_SHA
  patch-deployment:
    needs: [build-job]
    if: success()
    runs-on: ubuntu-latest
    # env:
    #   GIT_USER: ${{ secrets.k8s_user }}
    #   GIT_PASS: ${{ secrets.k8s_pass }}
      
    steps:
      
    - name: install git
      env:
        GIT_USER: ${{ secrets.k8s_user }}
        GIT_PASS: ${{ secrets.k8s_pass }}
      run: |
        sudo apt-get install -y git
        git clone -b prod/feature/devops https://user:token@github.com/BaziHassan/kubernetes-yaml.git
        ls
        cd kubernetes-yaml/prod-fabluentfe
        git config credential.helper store
        ls 
        rm -f deployment.yaml
        cat <<EOF >> deployment.yaml  
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          creationTimestamp: null
          labels:
            app: fabluentfe
          name: fabluentfe
          namespace: prod
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: fabluentfe
          strategy: {}
          template:
            metadata:
              creationTimestamp: null
              labels:
                app: fabluentfe
            spec:
              containers:
              - image: docker.io/bazihassan/prod-fabluentfeapp:$GITHUB_SHA
                name: fabluentfe-app
                imagePullPolicy: Always
                envFrom:
                - configMapRef:
                    name: fabluentfe-configmap
                - secretRef:
                    name: fabluentfe-secret
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
        git config --global user.email "envoyfacilitation@outlook.com"
        git config --global user.name "qasim-aziz"
        git add .
        git commit -m "from pipeline $GITHUB_SHA"
        git push origin prod/feature/devops


```