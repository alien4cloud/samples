In In this example,
attach  an existing AWS EBS Volume to a pod
verify the context of the volume. Normally nothing happens before the pod is stopped

In the prestop handler state , stop the pod. Before it stop , it will write inside the volume

to test whether the prestop handler succeded ,
after the pod is stopped , verifie that the volume contains the something (the index.html must
have been written in it).


