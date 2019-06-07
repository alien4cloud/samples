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

Events:
  Type     Reason     Age                From                                                  Message
  ----     ------     ----               ----                                                  -------
  Normal   Scheduled  2m3s               default-scheduler                                     Successfully assigned default/livenesskubedeployment-922360068-7b6f84984c-kvj9j to ip-172-31-44-159.eu-west-1.compute.internal
  Normal   Pulling    2m1s               kubelet, ip-172-31-44-159.eu-west-1.compute.internal  Pulling image "httpd:latest"
  Normal   Pulled     2m                 kubelet, ip-172-31-44-159.eu-west-1.compute.internal  Successfully pulled image "httpd:latest"
  Normal   Created    2m                 kubelet, ip-172-31-44-159.eu-west-1.compute.internal  Created container livenessapache--1790711595
  Normal   Started    2m                 kubelet, ip-172-31-44-159.eu-west-1.compute.internal  Started container livenessapache--1790711595
  Warning  Unhealthy  26s (x3 over 36s)  kubelet, ip-172-31-44-159.eu-west-1.compute.internal  Liveness probe failed: cat: /tmp/healthy: No such file or directory
  Normal   Killing    26s                kubelet, ip-172-31-44-159.eu-west-1.compute.internal  Container livenessapache--1790711595 failed liveness probe, will be restarted


After 85 seconds, view the Pod events again:
$ kubectl describe pod <pod-name>

At the bottom of the output, there are messages indicating that the liveness probes have failed,
and the containers have been killed and recreated.


Events:
  Type     Reason     Age                    From                                                  Message
  ----     ------     ----                   ----                                                  -------
  Normal   Scheduled  7m26s                  default-scheduler                                     Successfully assigned default/livenesskubedeployment-922360068-7b6f84984c-kvj9j to ip-172-31-44-159.eu-west-1.compute.internal
  Normal   Created    3m12s (x3 over 7m23s)  kubelet, ip-172-31-44-159.eu-west-1.compute.internal  Created container livenessapache--1790711595
  Normal   Started    3m12s (x3 over 7m23s)  kubelet, ip-172-31-44-159.eu-west-1.compute.internal  Started container livenessapache--1790711595
  Warning  Unhealthy  99s (x9 over 5m59s)    kubelet, ip-172-31-44-159.eu-west-1.compute.internal  Liveness probe failed: cat: /tmp/healthy: No such file or directory


After restart , execute this command to verify that the pod has restarted again.
$ kubectl get pod <pod-name>

NAME                                                READY   STATUS    RESTARTS   AGE
livenesskubedeployment-922360068-7b6f84984c-kvj9j   1/1     Running   8          26m

Here the command shows that the pod restarted 8 times