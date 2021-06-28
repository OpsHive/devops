		security in docker 

by default container run thier process as root user you can define user when you run
container or when you build image for container

 $ docker run --user=1000 ubuntu sleep 3600

you can also mention when build image

Dockerfile
----------

FROM ubuntu

USER 1000

----------------------------------------------------------

in docker when running as root user it can perform every task which is related to root user
so you can limit the rights and capabilities of root user in docker container

its imporatant to limit the capabilities beacuse user in docker container is like root user on
host...................

linux capabilities 
-------------------

CHOWN,DAC,KILL,SETFCAP,SETPCAP,SETGID,SETUID,NET_BIND,NET_RAW,MAC_ADMIN,BROADCAST,NET_ADMIN,
SYS_ADMIN,SYS_CHROOT,AUDIT_WRITE,MANY MORE


these all you can view at this path /usr/include/linux/capability.h

by default there are few capabilities which docker as root not have. if you wish to provide
you can provide more capabilites when run container

for example

 $ docker run --cap-add MAC_ADMIN ubuntu

you can drop privileged

 $ docker run --cap-drop KILL ubuntu

you can allow all privileged

 $ docker run --privileged ubuntu

--------------------------------------------------------------
you can define when creating pod 


apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-nginx-pod
    image: nginx
    securityContext:
      runAsUser: 0
      capabilities:
        add: ["SYS_ADMIN"]
 
if you wish to add on all containers in one go define after spec section

apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  securityContext:
    runAsUser: 0
    capabilities:
      add: ["SYS_ADMIN"]
  containers:
  - name: my-nginx-pod
    image: nginx

