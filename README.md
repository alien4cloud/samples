samples
=======

Samples archives for a4c.

The following components are in version 2.0.0 because they are compatible and tested with Ubuntu 12.04 and 14.04 :

* apache
* php
* mysql
* wordpress
* topology wordpress


The other components are still in SNAPSHOT version because we make regular changes.

Here is da magic command you should use to build csar:

```
if [ -d "playbook" ]; then echo "Zip playbook" && cd playbook && rm -f playbook.ansible && zip -r playbook.ansible * && cd ..; fi && rm -f *.zip && echo "Zip csar" && zip -r csar.zip *
```
