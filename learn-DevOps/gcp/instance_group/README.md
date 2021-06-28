# instance group auto scaler
if you need geo routing you can create vpc with two or more subnets and create template according to your servers location, and also create
database with private network over same vpc which you create. so every server will connect with thier on db with thier respective subnets.
## Step 1. instance group
Navigate to compute engine select instance group create instance-group provide name and zone you can also select autoscaling and number of instances

## Step 2. instance Template
you need to create instance template which used ny instance group when it scale up it will take this template and run instance 
1. provide name
2. select image for os
3. select networks if created your own vpc network.
4. on management tab you can provide initial script which run when it create instance. for example

### initial script for running instance.
before thisscript you spouse  to already  build and push images on gcr

```
#! /bin/bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install -y docker-ce

sudo usermod -aG docker $USER

sudo chown root:docker /var/run/docker.sock
sudo chown -R root:docker /var/run/docker
sudo chown -R $USER:docker /var/run/docker
sudo chown $USER:docker /var/run/docker.sock
docker ps

# this is service account json.key | you can create service account with storage admin role for building, pushing, pulling docker images.

cat <<EOF >> gcloud.json

# put  all contents of json.key here for example 
{
  all contenct of json key.
}


EOF

sudo cp gcloud.json /etc/docker/key.json
whoami
ls
pwd

cat gcloud.json | docker login -u _json_key --password-stdin https://gcr.io
docker run --name=redis -d -p 6379:6379
docker run --name=frontend -d -p 80:80 gcr.io/project/frontend-app:0.0.1
docker run --name=backend -d -p 8000:8000 gcr.io/project/backend-app:0.0.1
docker exec -it backend sh -c "python manage.py collectstatic –-no-input"
docker exec -it backend sh -c “python manage.py makemigrations”
docker exec -it backend sh -c “python manage.py migrate”
docker ps

```

create template

after that you can choose settings for autoscaling and provide details on instance group how many instance you need to scale max and min numbers

create instance group and wait.

## step 3. Loadbalancer

after creating successfully instance group then you can create load balancer 
1. choose name of loadbalncer
2. create backends where it routs traffic , you can create more than noce backends for geo routing. 
3. create frontend and health checks for load balncer 

test with curl -v $loadbalncerip 

# thanks 