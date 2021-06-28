# create and use image pull secret for gcp

## Steps 1: Create Credentials for GCRGo to the GCP Console. Select “API & Services” > “Credentials”Select “Create credentials” > “Services Account Key” > “Create New Services Account”.
And then, fill the service account name, and for the Role, select the ViewerAnd click Create.
After we create, the credential will automatically be downloaded in a JSON file.
 It will be looks like this.

So now, we already have credentials that able to pull private images from GCR.

## Steps 2: Add a Kubernetes Secret in Kubernetes ClusterAnd the next step is, we will create a Kubernetes secret in our Kubernetes cluster


```

kubectl create secret docker-registry gcr-json-key \<br>  --docker-server=asia.gcr.io \<br>  --docker-username=_json_key \<br>  --docker-password="$(cat ~/json-key-file-from-gcp.json)" \<br>  --docker-email=any@valid.email


```

Run the command above and input based on your needs. For example: docker-server: asia.gcr.io (I use the Asia server).
 And fill the email with your registered email in GCP and so on


## Steps 3: Using the Secret for Deployment





There are 2 ways how do we can use the created secret from previous steps. They are

Add the secret into ImagePullSecrets in default service account in a Kubernetes’s namespace. 
With this method, every pod that will be deployed will use the secret when pulling the images.
The other way is, add the secret directly to deployment configuration to each pod who needs it.


## Steps 3.a: Add the Secret to “ImagePullSecrets” in the Default Service Account.

The first way is with adding the secret in the default service account. To do this,
 we can directly copy this command below

```
kubectl patch serviceaccount default \<br>-p '{"imagePullSecrets": [{"name": "gcr-json-key"}]}'

```

## Steps 3.b: Add the Secret to Each Pods Deployment Configuration


And for this step, we need to update our deployment file. And we need to add the secret directly to the deployment file.
 And this method only works for each pod that has the secret included.

Looks for the property: imagePullSecrets. We must add the secret directly in our deployment file.

And for my case, I choose the first method, the reasons is because my default container registry is GCR.
So if in the future I have a different registry, 
I will just add in the deployment file directly to each pod who need it.


