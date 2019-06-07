In this example,
We ll demonstate how to attach/detach Persistent volume to a node.
We will use AWS EBS volume for sample. The EBS was created already on AWS.
(for this example, its id is: vol-042a55a30150dfdde). This id is set in aws source node_template
(AWSElasticBlockStoreVolumeSource)of our topologie. The Aws volume must be on same zone as the container (ex: eu-west-1b)
When deploying the topologie, don't forget to change it and set your own volume id.

NB: The volume size specified in deployment is the minimum size needed.
    If the size specified in deployment is low or greater that the available volume created on aws ,
    kubernetes will use all the available volume even if is not enough for specified size.
    If the available volume size on aws is not enough, the deployment will crash.


    You can check the size of volume mounted on pod using command :
    # df -Th
    Filesystem     Type     Size  Used Avail Use% Mounted on
    overlay        overlay   16G  6.8G  8.7G  44% /
    tmpfs          tmpfs     64M     0   64M   0% /dev
    tmpfs          tmpfs    7.8G     0  7.8G   0% /sys/fs/cgroup
    /dev/nvme0n1p1 ext4      16G  6.8G  8.7G  44% /etc/hosts
    shm            tmpfs     64M     0   64M   0% /dev/shm
    /dev/nvme1n1   ext4      98G   61M   98G   1% /usr/local/apache2/htdocs



Then using apache container , the volume is mounted at "/usr/local/apache2/htdocs"
in order to write inside an index.html file.
The content of this file is passed through command line and will be displayed by
the apache service on web page.

To verify that our EBS volume has realy the index file inside, create a new aws instance
then attach the EBS volume on it

ATTACHING VOLUME TO AN AWS INSTANCE (https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/ebs-attaching-volume.html):
1.Ouvrez la console Amazon EC2 à l'adresse https://console.aws.amazon.com/ec2/.
2.Dans le panneau de navigation, choisissez Elastic Block Store, Volumes.
3.Sélectionnez le volume et choisissez Actions, puis Attacher un volume.
4.Dans le champ Instance, saisissez le nom ou l'ID de l'instance.
  Sélectionnez l'instance dans la liste des options (seules les instances qui sont dans la même
  zone de disponibilité que le volume sont affichées).
5.Pour Dispositif, vous pouvez conserver le nom d'appareil suggéré (/dev/xvdf)
6.Choisissez Attacher.
7.Connectez-vous à votre instance et montez le volume. Pour plus d'informations,
  consultez Rendre un volume Amazon EBS disponible à l'utilisation sur le Linux.

READING VOLUME: (https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/ebs-using-volumes.html)
1. [ec2-user ~]$ lsblk
2. [ec2-user ~]$ sudo file -s /dev/xvda1    (Display data on volume)
3. [ec2-user ~]$ sudo mkdir /data
4. [ec2-user ~]$ sudo mount /dev/xvdf /data
5. [ec2-user ~]$ ls /data  : here will se the index.html file created by the container



