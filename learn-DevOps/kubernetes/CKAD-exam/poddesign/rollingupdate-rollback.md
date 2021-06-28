		Rollout and Versioning

when first you create deployment it create first rollout, and when you make a new
rollout it create a history of you deployment version through which can can rollback
on previous versioning 


Roll out Commands

if you want to see status you deployment

 $ kubectl rollout status deployment <deployment-name>

 $ kubectl rollout status deployment my-deployment 
----------------------------------------------------------------

if you want to check history of rollout 



 $ kubectl rollout history deploy <deployment-name>

 $ kubectl rollout history dpeloy my-deployment

---------------------------------------------------------------

Deployment Strategy


there are two type of strategy

*Recreate:-

	it deleted all pod once and then recreate again so down time face by users when
it update images its not default strategy but you can use if neccesssory to define in yamls.

*Rolling Update:-
	it not destroy all pods once it terminate pod one by one and create new one along side
so one terminate and one create so in this strategy users not face down time and its default
type ...


--------------------------------------------------------------


you can update image of deployment by

 $ kubectl set image deployment <deployment-name> <container-name>=nginx:1.9.1

 $ kubectl set image deployment my-deployment nginx=nginx:1.9.1

you can maitain record by seting --record=true

 $ kubectl set image deployment my-deployment nginx=nginx:1.9.1 --record=true
-------------------------------------------------

you can check history of deployment by 

 $ kubectl rollout history deployment my-deployment

if you want to check a specific history revision you can by

 $ kubectl rollout history deployment my-deployment --revision=1



you can rollback you change regarding set image 


 $ kubectl rollout undo deployment <deployment-name>

 $ kubectl rollout undo deployment my-deployment

if you want to undo a specific revision you can do with 

 $ kubectl rollout undo deployment my-deployment --to-revision=2


-------------------------------------------
help full commands in deployment

it will pause the change of image change 

 $ kubectl rollout pause deployment my-deployment

it will resume the change of image change

 $ kubectl rollout resume deployment my-deployment





