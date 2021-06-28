	taint and toleration and affinity

when we have 5 nodes  having taints red,blue, green, other, other... so we want
 to deploy 3 pod and in pod definiation file each of toleration by repective
 names like, red,blue and green so in taint and toleration its not mendatory all
 pod should place on thier respective nodes for example some of they only tolerate if
scheduler deploy on these node so in that case we use affinity and labels our nodes
with red,blue,green and with affinity seletor we can mention in pod yaml file pods 
should must be deploy on thier repective nodes.......
 
