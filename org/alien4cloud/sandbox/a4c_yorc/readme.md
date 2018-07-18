# You need a linux box with centos (tried on a EC2 ami-3548444c t2.medium)

# You need the following vars:
# - REMOTE_IP_ADDRESS: ie. 34.245.10.8
# - REMOTE_USER: ie. centos
# - PRIVATE_KEY_PATH: ie. ~/work/env/aws/keys/vicos-awsproductteam.pem

# Rename inputs.json.tpl to inputs.json and setup few things (a minima 'a4c_ip').

# if you want to activate SSL for A4C (HTTPS) you need to set 'a4c_protocol' to 'https' and to generate a keystore
# the script resources/ssl.sh will generate all autosigned stuff for you
./resources/ssl.sh $REMOTE_IP_ADDRESS changeIt!
# if it prompt for a pwassword, it needs the root password of your own machine !
# it will finally echo you something like :
> Generated key store in : /var/folders/2d/3krvvvn538ggxjx8mtvwmj_c0000gn/T/tmp.vaCqIRYH/server-keystore.p12
# fill the 'ssl_keystore_source_location' in inputs.json file using this path

# Install all stack on the remote machine
ansible-playbook -i $REMOTE_IP_ADDRESS, install-a4c-consul-yorc.yml --private-key $PRIVATE_KEY_PATH --user $REMOTE_USER --extra-vars "@inputs.json" -v

# Configure A4C
ansible-playbook -i $REMOTE_IP_ADDRESS, setup-a4c-artemis.yml --private-key $PRIVATE_KEY_PATH --user $REMOTE_USER --extra-vars "@inputs.json" -v

# That's all folk, the full system will be available

# To test the integration between A4C and Yorc:
# - Go to 'Application' / 'Nouvelle Application'
# - Give a name to your app (ie. MyFirstTest)
# - In 'Modèle de topologie', choose '1TinyMock' template
# - Click on 'Créer'
# - In 'Work on an environment' section, click on the line 'Environment OTHER 0.1.0-SNAPSHOT'
# - Choose the "AWS Orchestrator: Yorc" under the 'Locations' blue button
# - Click on 'Vérifier & activer'
# - Click on 'Activer'
# - You will then see a progess bar ... if all is finally green, all is OK.
# - Click on 'Désactiver'
