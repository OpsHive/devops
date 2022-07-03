docker login -u AWS -p $(aws ecr get-login-password --region us-east-2) 707025529362.dkr.ecr.us-east-2.amazonaws.com

if you  want to login from  cli create ecr repository and copy the repo name and replace in above commmand. also make sure to use correct region ame 
