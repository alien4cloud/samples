In this example,
We ll demonstate how to attach/detach dynamically  Persistent volume to a node.
We will use AWS EBS volume for sample.
This example will use the default storage class and a persistent volume created already sur kubernetes


CREATING A PPERSISTENT VOLUME WITH DEFAULT STORAGE CLASS :
----------------------------------------------------------
kind: PersistentVolume
apiVersion: v1
metadata:
  name: test-defaut-storageclass-pv-volume
  labels:
    type: local
spec:
  storageClassName: default
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"


NB: the storage must be >= than pvc storage

------------------------------------------------------------------------------------------------------
VERIFY WHETHER THE DEFAULT STORAGE CLASS EXIST  ( standard (default) ):

[centos@ip-172-31-41-215 kubernetes]$ kubectl --kubeconfig /etc/kubernetes/admin.conf  get storageclass

NAME                 PROVISIONER             AGE
standard (default)   kubernetes.io/aws-ebs   18m
testgold             kubernetes.io/aws-ebs   23h

-------------------------------------------------------------------------------------------------------
IN CASE THAT THE DEFAULT CS NOT EXISTS , CREATE ONE  AND MAKE IT DEFAULT:

kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: standard
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2


kubectl --kubeconfig /etc/kubernetes/admin.conf  patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'