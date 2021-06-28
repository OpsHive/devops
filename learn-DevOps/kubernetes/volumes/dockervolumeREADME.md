		Docker Volumes

as default docker stores all data at /var/lib/docker and all images volumes etc stores
at this place ...

we can create new volumes and mount with the docker container ,

	$ docker volume create data_volume

and we can run container with mounting volume with

	$ docker run -v data_volume:/var/lib/mysql mysql

in case spouse you have not created a data_volume when you run command volume will be 
automatically created by the docker 

	$ docker run -v data_volume2:/var/lib/mysql mysql


but what if we have data already at another location like /data/mysql so in that case
when we run docker run command we can specify 
	
	$ docker run -v /data/mysql:/var/lib/mysql mysql

it will create a mysql container and mount the data at /data/mysql so its called bind
mount, there two type of volume mount and bind mounting...

volume mount is when data mounted as default /var/lib/docker/volume 
bindmount mean when we bind any directory in our system as volume in docker container.

there are two ways of running command one way is -v flag and another is use --mount

	$ docker run --mount type=bind,source=/data/mysql,target=/var/lib/mysql mysql

in this command type=bind and source=/data/mysql is which directory of you file system
you want to mount and target=/var/lib/mysql is where you want to mount data within 
container

Storage drivers

	-AUFS
	-ZFS
	-BTRFS
	-Device Mapper
	-Overlay
	-Overlay2

AUFS available with ubuntu operating system.....device Maper is for centos etc...


---------------------------------------------------------------------------------

	volumes driver plugins in docker 

volumes are not handled by storage drivers volumes are handled by volumes driver plugins
the default volume driver plugin is local , local volume plugin helps to create volume
at /var/lib/docker there are verious other plugin that helps create volume at  third 
party solution like azure file storege,Convoy,DigitalOcean Block storage,Flocker,
gce-docker,GlusterFS,Netapp,RexRay,Portworx,VMware vSphere Storage these are few from 
many...

for example 

	$ docker run  -it --name mysql \
 --volume-driver rexray/ebs --mount src=ebs-vol, target=/var/lib/mysql mysql

it will run container mysql and mount the volume on aws service ebs (elastic block storage)
 
