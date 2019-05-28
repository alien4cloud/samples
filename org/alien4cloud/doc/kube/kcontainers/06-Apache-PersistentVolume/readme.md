In this example,
We ll demonstate how to attach/detach Persistent volume to a node.
We will use AWS EBS volume for sample. The EBS was created already on AWS.
(for this example, its id is: vol-042a55a30150dfdde)

Then using apache container , the volume is mounted at "/usr/local/apache2/htdocs"
in order to write an index.html file in it.
The content of this file is passed through command line and will be displayed by
the apache service on web page.

To verify that our EBS volume has realy the index file inside, create an aws instance
then attach the EBS volume on it

ATTACHING VOLUME (https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/ebs-attaching-volume.html):
1.Ouvrez la console Amazon EC2 à l'adresse https://console.aws.amazon.com/ec2/.
2.Dans le panneau de navigation, choisissez Elastic Block Store, Volumes.
3.Sélectionnez le volume et choisissez Actions, puis Attacher un volume.
4.Dans le champ Instance, saisissez le nom ou l'ID de l'instance.
  Sélectionnez l'instance dans la liste des options (seules les instances qui sont dans la même
  zone de disponibilité que le volume sont affichées).
5.Pour Dispositif, vous pouvez conserver le nom d'appareil suggéré ou entrer un autre nom d'appareil pris en charge.
   Pour plus d'informations, consultez Noms d'appareil pour les instances Linux.
6.Choisissez Attacher.
7.Connectez-vous à votre instance et montez le volume. Pour plus d'informations,
  consultez Rendre un volume Amazon EBS disponible à l'utilisation sur le Linux.

READING VOLUME: (https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/ebs-using-volumes.html)
1. [ec2-user ~]$ lsblk
2. [ec2-user ~]$ sudo file -s /dev/xvda1    (Display data on volume)
3. [ec2-user ~]$ sudo mkdir /data
4. [ec2-user ~]$ sudo mount /dev/xvdf /data
5. [ec2-user ~]$ ls /data  : here will se the index.html file created by the container



