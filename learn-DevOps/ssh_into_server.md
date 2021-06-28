when you want to deploy through github actions 

first create authorized public and private keys so follow these steps 

step 1

on you local system from where you push your changes  run this command 

 $ ssh-keygen -m PEM -t rsa -b 4096 -C "staging_key"

it will ask you for name of public and private keys you can provide which you want in my case id_rsa_staging_key
other steps will be only press enter with out giving any passprase 


step 2
then at location /home/username/.ssh find pair of public and private keys 
copy private key with name of id_rsa_staging_key and add to your github repos secret


step3

then find and copy the contents of public key which is id_rsa_staging_key.pub and save it in authorized_keys

authorized keys will also be at /home/username/.ssh/authorized_keys

edit authorized keys and at the top of the file paste content of id_rsa_staging_key.pub and save and exit


---------------------------------------------------------------------------

repeate all steps for production keys change name according id_rsa_production_key  ...



-------------------------

use this script in workflow


name: Docker build for Laravel

on:
  push:
    branches:
      staging

jobs:
  
  Deploy-job:
    name: Deploy
    runs-on: ubuntu-latest
    steps:
    - name: testing Deployment
      uses: appleboy/ssh-action@master
      with:
        host: 70.40.220.132
        username: edudrift
        password: Engineering2018*
        #key: ${{ secrets.OMG_SECRET }}
        port: 22
        use_insecure_cipher: true
        script: |
          mkdir my-new-test
