		Docker security

in docker when we create container , container is isolate only by the namespace but using
host-machine kenrel so with root user of host machine you can list thier process and by default
proccess in the container as root user. it mean if your process in container as root
user is same like root user in hostmachine , so we have to manage security in docker container
by setting up USER in docker file so when container start it will not be login by root
user

for example Dockerfile will be like this

	FROM ubuntu
	
	USER 1000

 $ docker build -t my-ubuntu-image .
 
 $ docker run my-ubuntu-image sleep 3600

 $ ps aux

so you can get user as 1000  

----------------------------------------------------------------------------------------

		LINUX CAPABILITIES

root user of linux can perform each and every operations in linux, it can add,delete user,
add, delete ,create group, modify host, bind host ,start , kill, create ,delete operations 

you can see all capabilities in => this location  /usr/include/linux/capability.h

by default in container user have limited capabilites so you can provide more capabilites or 
provide some more limited capabilites you can do by these commands

	$ docker run --cap-add MAC_ADMIN ubuntu

you can provide capabilites by --cap-add flag

similarly you can drop capabilites by 

	$ docker run --cap-drop KILL ubuntu

and you can provide all previliges same  as hostmachine root user by

	$ docker run --privileged ubuntu

so within the containers you can perform like hostmachine root user..... 
