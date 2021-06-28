if you want to genterate pod with-out yaml your can use impertive way direct by thi command
    
    $ kubectl run --generator=run-pod/v1 nginx-pod --image=nginx:alpine
    
--generator=run-pod/v1 is tell to kubernetes engin to create only pod by default withoud this --genrator it will create deployment.

