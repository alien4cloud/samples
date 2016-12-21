Needs the following stuff to be installed on the manager :

- ansible
- boto (for the ec2 ansible module)
- modified tree.py (Cf. A4C ansible documentation)

To build the CSAR, zip the 'playbook' folder into playbook/playbook.ansible and zip the whole CSARS

```
cd playbook && rm -f playbook.ansible && zip -r playbook.ansible * && cd .. && rm -f stuff.zip && zip -r stuff.zip *
```
