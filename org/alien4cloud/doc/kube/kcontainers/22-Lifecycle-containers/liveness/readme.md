Source : https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/

in this example , we create a Pod that runs a Container

To perform a probe, the kubelet executes the command cat /tmp/healthy in the Container.
If the command succeeds, it returns 0, and the kubelet considers the Container to be alive and healthy.
If the command returns a non-zero value, the kubelet kills the Container and restarts it.

When the Container starts, it executes this command:
/bin/sh -c "touch /tmp/healthy; sleep 80; rm -rf /tmp/healthy; sleep 160"

For the first 80 seconds of the Container’s life, there is a /tmp/healthy file. So during the first 80 seconds,
the command cat /tmp/healthy returns a success code. After 80 seconds, cat /tmp/healthy returns a failure code.


To test that our test sussessfully :

Within 80 seconds, view the Pod events:
$ kubectl describe pod <pod-name>

The output indicates that no liveness probes have failed yet,

After 85 seconds, view the Pod events again:
$ kubectl describe pod <pod-name>

At the bottom of the output, there are messages indicating that the liveness probes have failed,
and the containers have been killed and recreated.


After restart , execute this command to verify that the pod has restarted again.
$ kubectl get pod <pod-name>

Here the command shows that the pod restarted