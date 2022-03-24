
## we have to find project id over gitlab in this case project id is 8 . find project it accordingly and replace it

```
helm repo add --username <git-user>  --password <git-user-token> fabluent https://git.cloudlaunch.io/api/v4/projects/8/packages/helm/stable

```



## install helm plugin for push charts over registry 
```
helm plugin install https://github.com/chartmuseum/helm-push

```

## push chart tgz file to helm registry which we have added in previous steps.  
```
helm cm-push fab-backend-0.1.0.tgz fabluent

```
