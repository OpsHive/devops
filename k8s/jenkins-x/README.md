
# we assume your google sdk setup

## Download binary 
To install Jenkins X on Linux, download the .tar file, and unarchive it in a directory where you can run the jx command.

1. Download the jx binary archive using curl and pipe (|) the compressed archive to the tar command:

        $ curl -L "https://github.com/jenkins-x/jx/releases/download/$(curl --silent "https://github.com/jenkins-x/jx/releases/latest" | sed 's#.*tag/\(.*\)\".*#\1#')/jx-linux-amd64.tar.gz" | tar xzv "jx"
 
2. Install the jx binary by moving it to a location in your executable path using using the mv command

        $ sudo mv jx /usr/local/bin ```

3. check version of jx

        $ jx version --short ```


### before proceed next you need to set PROJECT_ID as environmental variable 
### add two github users over github orgnizations account and genrate token for both from these privliges shown in this link this link
### login from github orgnizations account and then past this in brwoser so then it will take you to generate token from github orgnizations account and save  
        https://github.com/settings/tokens/new?scopes=repo,read:user,read:org,user:email,write:repo_hook,delete_repo


### command

        $ export PROJECT_ID="TELCO-TEAM" ```


# installation jenkinsx over  gke cluster
### requriements to start
    1. create new user over linux and provide sudo previlliges for example 

### jx create cluster gke will create a cluster on Google Kubernetes Engine (GKE), which you can initialise with a name. From the command-line run:
        $ jx create cluster gke --skip-installation -n <cluster name> 


now clone this repository over you system cd to jenkins-x-boot-config 

        https://github.com/jenkins-x/jenkins-x-boot-config.git

now its time to intiate jx boot command after that there are many thing you will provide which asked by jx boot so be carefully provide all you answers to setup
jx installation on kubernetes cluster 

        $ jx boot

Do you want to jx boot the demo-cluster cluster? Yes

Git Owner name for environment repositories  ```cloudcontributor```

Comma-separated git provider usernames of approvers for development environment repository ```<github-user-as-memeber-which-you-added-over-orgnization-account>```

WARNING: TLS is not enabled so your webhooks will be called using HTTP. This means your webhook secret will be sent to your cluster in the clear. See https://jenkins-x.io/docs/getting-started/setup/boot/#ingress for more information
? Do you wish to continue? ```Yes```

? Jenkins X Admin Username admin

? Jenkins X Admin Password [? for help] ***********

? Pipeline bot Git username ```second-github-boot-user-as-member-which-you-added-over-orgnization-account```

? Pipeline bot Git email address ```boot-email-address-from-which-you-create-boot-github-user-account```

? Pipeline bot Git token [? for help] ****************************************


Generated token 0da7534cffeacc4b5ec65c93c5b351c54f67c695e, to use it press enter.
This is the only time you will be shown it so remember to save it
? HMAC token, used to validate incoming webhooks. Press enter to use the generated token [? for help] 


? Do you want to configure non default Docker Registry? No 



### Now jenkinx setup over cluster now you can import you repository 

# Importing Github orgnizatioins repository as pipeline

        jx import --url https://github.com/cloudcontributor/customerqueue.git


it will asked some questions so as github user account you provide github-user-boot-account 

you can verify by this command

        jx get applications













    




