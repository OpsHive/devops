
ci image build and patch deployment.


```

name: dev cleo CI & image build&push 

on:
  push:
    branches:
    - feature/devops

jobs:
  app-ci:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [14.x]
    
    steps:
    - uses: actions/checkout@v2

    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v1
      with:
        node-version: ${{ matrix.node-version }}
    - run: npm update 
    - run: npm i
    
  
  build-job:
    needs: [app-ci]
    if: success()
    name: Docker build
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }} 
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }} 
        aws-region: ap-south-1
    
    - name: Login to Amazon ECR
      id: login-ecr
      uses: aws-actions/amazon-ecr-login@v1

    - name: Build, tag, and push image to Amazon ECR
      env:
        ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
        ECR_REPOSITORY: prod-cleo
        IMAGE_TAG: ${{ github.sha }}
      run: |
        docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$GITHUB_SHA .
        docker push $ECR_REGISTRY/$ECR_REPOSITORY:$GITHUB_SHA
  
  patch-deployment:
    needs: [build-job]
    if: success()
    runs-on: ubuntu-latest
      
    steps:
      
    - name: patch deployment
      run: |
        sudo apt-get install -y git
        git clone -b k8s https://user:token@github.com/jaisondavis/cleo.git
        cd cleo/k8s
        git config credential.helper store
        rm -f deployment.yaml
        cat <<EOF >> deployment.yaml  
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          creationTimestamp: null
          labels:
            app: cleo
          name: cleo
          namespace: default
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: cleo
          strategy: {}
          template:
            metadata:
              creationTimestamp: null
              labels:
                app: cleo
            spec:
              containers:
              - image: 619449222344.dkr.ecr.ap-south-1.amazonaws.com/prod-cleo:$GITHUB_SHA
                name: cleo-app
                imagePullPolicy: Always
                envFrom:
                - configMapRef:
                    name: cleo-configmap
                - secretRef:
                    name: cleo-secret
                # resources:
                #   requests:
                #     memory: "64Mi"
                #     cpu: "250m"
                #   limits:
                #     memory: "128Mi"
                #     cpu: "500m"
              # imagePullSecrets:
              # - name: regcred
        EOF
        git config --global user.email "envoyfacilitation@outlook.com"
        git config --global user.name "qasim-aziz"
        git add .
        git commit -m "from pipeline $GITHUB_SHA"
        git push origin k8s

```