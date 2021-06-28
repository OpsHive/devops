there is need of collects logs of containers to ensure containers configured proberly and what
are the states of internal application


you can view


 $ kubectl logs <pod-name>

 $ kubectl logs nginx


for live logs of pod by 

 $ kubectl logs -f nginx

--------------------------------------------------------------

in multicontainer senerio

 $ kubectl logs <pod-name> -c <container-name>

 $ kubectl logs -f <pod-name> -c <container-name>


